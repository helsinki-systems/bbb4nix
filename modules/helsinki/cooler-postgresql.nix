{ config, pkgs, lib, ... }: with lib; let
  cfg = config.helsinki.cooler-postgresql;

  mkNo = cond: optionalString (!cond) "NO";

  creationArgs = cfg': let
    args = ""
      + optionalString (cfg'.encoding != null) " ENCODING \"${cfg'.encoding}\""
      + optionalString (cfg'.collate != null) " LC_COLLATE=\"${cfg'.collate}\""
      + optionalString (cfg'.ctype != null) " LC_CTYPE=\"${cfg'.ctype}\"";
  in if args != "" then "WITH ${args}" else "";

  ensureScript = pkgs.writeScript "postgresql-ensure" ''
    #!${pkgs.stdenv.shell}
    set -e
    set -u
    set -o pipefail

    /run/wrappers/bin/sudo -u postgres psql <<EOF
      DO
      \$do$
      BEGIN
      CREATE EXTENSION IF NOT EXISTS dblink;
      -- Ensure it's not possible to connect to random databases
      REVOKE CONNECT ON DATABASE template1 FROM PUBLIC;
      GRANT CONNECT ON DATABASE postgres to postgres;
      REVOKE CONNECT ON DATABASE postgres FROM PUBLIC;

      -- Ensure roles
      ${concatStringsSep "\n" (mapAttrsToList (name: options: ''
        -- Ensure existence
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '${name}') THEN
          RAISE NOTICE 'Role already exists';
        ELSE
          CREATE ROLE "${name}";
        END IF;

        -- Grant schema usage
        GRANT USAGE ON SCHEMA public TO "${name}";

        -- Ensure other stuff
        ALTER ROLE "${name}"
          ${mkNo options.superuser}SUPERUSER
          ${mkNo options.createDatabases}CREATEDB
          ${mkNo options.allowLogin}LOGIN
          ${optionalString options.noPassword "PASSWORD NULL"}
          ${optionalString (options.password != null) "PASSWORD '${options.password}'"}
          ${optionalString (options.passwordFile != null) ''PASSWORD '$(grep -Po "${options.passwordFileRegex}" "${options.passwordFile}")' ''};
      '') cfg.ensureRoles)}

      END
      \$do$;

      DO
      \$do$
      BEGIN

      -- Ensure databases
      ${concatStringsSep "\n" (mapAttrsToList (name: options: ''
        -- Ensure existence
        IF EXISTS (SELECT 1 FROM pg_database WHERE datname = '${name}') THEN
          RAISE NOTICE 'Database already exists';
        ELSE
          PERFORM dblink_exec('dbname=' || current_database(), 'CREATE DATABASE ${name} ${creationArgs options}');
        END IF;

        -- Ensure owner
        ${optionalString (options.owner != null) ''
          PERFORM dblink_exec('dbname=' || current_database(), 'ALTER DATABASE ${name} OWNER TO ${options.owner}');
        ''}

        -- Ensure extensions
        ${concatStringsSep "\n" (map (ext: ''
          PERFORM dblink_exec('dbname=${name}', 'CREATE EXTENSION IF NOT EXISTS ${ext}');
        '') options.extensions)}

        -- Ensure grants
        ${concatStringsSep "\n" (map (role: ''
          GRANT CONNECT ON DATABASE ${name} TO ${role};
          PERFORM dblink_exec('dbname=${name}', 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${role}');
          PERFORM dblink_exec('dbname=${name}', 'GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${role}');
        '') options.roles)}
      '') cfg.ensureDatabases)}

      ${cfg.extraSQLCommands}
      END
      \$do$;
    EOF
  '';

in {
  options.helsinki.cooler-postgresql = with types; {
    enable = mkEnableOption "a cooler PostgreSQL module";

    package = mkOption {
      type = package;
      description = "PostgreSQL package to use";
      default = pkgs.postgresql_11;
      defaultText = "pkgs.postgresql_11";
    };

    ensureDatabases = mkOption {
      default = {};
      description = "Databases to create";
      type = attrsOf (submodule ({ name, ... }: {
        options = {
          name = mkOption {
            visible = false;
            default = name;
            type = str;
            description = "Name of this database";
          };

          owner = mkOption {
            type = nullOr str;
            description = "Owner of this database";
            default = null;
          };

          extensions = mkOption {
            type = listOf str;
            description = "Extensions to load";
            default = [];
          };

          encoding = mkOption {
            type = nullOr str;
            description = "Encoding of this database. Only applied on creation time";
            default = null;
            example = "UTF-8";
          };

          collate = mkOption {
            type = nullOr str;
            description = "Collate of this database. Only applied on creation time";
            default = null;
            example = "en_US.UTF-8";
          };

          ctype = mkOption {
            type = nullOr str;
            description = "Ctype of this database. Only applied on creation time";
            default = null;
            example = "en_US.UTF-8";
          };

          roles = mkOption {
            type = listOf str;
            description = "Roles which are allowed to use this database";
            default = [];
          };
        };
      }));
    };

    ensureRoles = mkOption {
      default = {};
      description = "Roles to create";
      type = attrsOf (submodule ({ name, ... }: {
        options = {
          name = mkOption {
            visible = false;
            default = name;
            type = str;
            description = "Name of this role";
          };

          superuser = mkOption {
            type = bool;
            description = "Whether this role is a superuser";
            default = false;
          };

          createDatabases = mkOption {
            type = bool;
            description = "Whether this role is allowed to create databases";
            default = false;
          };

          allowLogin = mkOption {
            type = bool;
            description = "Whether this role is allowed log in";
            default = true;
          };

          password = mkOption {
            type = nullOr str;
            description = "Encrypted or plain-text password for the role. Set to null to keep as-is";
            default = null;
          };

          passwordFile = mkOption {
            type = nullOr str;
            description = "File to read the password from";
            default = null;
          };

          passwordFileRegex = mkOption {
            type = str;
            description = "Regular expression to find the password in the file";
            default = ".*";
          };

          noPassword = mkOption {
            type = bool;
            description = "Enable this option to remove the role's password";
            default = false;
          };
        };
      }));
    };

    extraSQLCommands = mkOption {
      type = lines;
      description = "Extra SQL commands to execute after everything else is ensured";
      default = "";
    };
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = cfg.package;

      # Configure hba
      authentication = mkAfter ''
        local all postgres ident
        local all all      md5
      '';
    };

    systemd.services.postgresql-ensure = {
      description = "Ensure some PostgreSQL data exists";
      after = [ "postgresql.service" ];
      requires = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ cfg.package ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = ensureScript;

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        CapabilityBoundingSet = "CAP_SETUID CAP_SETGID CAP_DAC_READ_SEARCH";
        AmbientCapabilities = "CAP_SETUID CAP_SETGID CAP_DAC_READ_SEARCH";
        NoNewPrivileges = true;

        LockPersonality = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        MemoryDenyWriteExecute = true;
        SystemCallFilter = "~@chown @clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @raw-io @reboot @resources @swap";
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "AF_UNIX";
      };
    };

    systemd.services.postgresql = {
      sandbox = 1;
      serviceConfig = {
        StateDirectory = mkForce "postgresql";

        PrivateNetwork = false;
        PrivateUsers = false;

        SystemCallFilter = "@sync @system-service";
      };

      apparmor = {
        enable2 = true;
        packages = [ cfg.package ];
        extraConfig = ''
          /etc/passwd r,
          /dev/shm/** rw,
          # For mmap
          / rw,

          network unix stream,
          network unix dgram,
          network inet stream,
          network inet dgram,
          network inet6 stream,
          network inet6 dgram,
          deny network netlink raw,
        '';
      };
    };
  };
}
