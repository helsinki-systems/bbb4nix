{ lib, helsinkiLib, pkgs, config, ... }: let
  cfg = config.services.bigbluebutton.b3scale;
in {
  options.services.bigbluebutton.b3scale = {

    enable = lib.mkEnableOption "b3scaled or b3scalenoded, depending on if this host is the master or not";

    configureDB = lib.mkEnableOption "configure a postgres database" // { default = true; };

    loadFactor = lib.mkOption {
      type = lib.types.str;
      default = "1.0";
      description = "Load factor of the backend";
    };

    master = lib.mkOption {
      type = lib.types.str;
      description = "Hostname of the master/load-balancer node";
    };

    backends = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = "Hostnames of backends";
    };
  };

  config = lib.mkIf cfg.enable (let
    commonService = {
      sandbox = 2;
      apparmor = {
        enable = true;
        extraConfig = ''
          /sys/kernel/mm/transparent_hugepage/hpage_pmd_size r,
          /proc/sys/net/core/somaxconn r,

          network tcp,
        '';
      };

      stopIfChanged = false;

      serviceConfig = {
        User = "b3scale";
        Group = "b3scale";

        PrivateUsers = false;
        PrivateNetwork = false;

        Restart = "on-failure";
        RestartSec = "2s";
      };

      wantedBy = [ "bigbluebutton.target" ];
    };

    isMaster = (config.networking.hostName == cfg.master);

    backendAddrs = lib.concatMap (b: with helsinkiLib.hosts."${b}.wg"; v4 ++ v6) cfg.backends;
  in {
    systemd.services = if isMaster then
      lib.mkMerge [ { b3scaled = commonService; }
        {
          b3scaled = {
            serviceConfig = {
              ExecStart = "${pkgs.b3scale}/bin/b3scaled";
            };

            preStart = ''
              export ON_ERROR_STOP=on
              if [ $(${config.helsinki.cooler-postgresql.package}/bin/psql -c '\dt'|wc -l) -lt 10 ]; then
                ${config.helsinki.cooler-postgresql.package}/bin/psql < ${pkgs.b3scale.src}/db/schema/0001_initial_tables.sql
              fi
            '';

            requires = [ "postgresql.service" ];

            apparmor.extraConfig = ''
              unix (create,getopt,getattr) addr=none,
              /etc/passwd r,

              network udp,

              /run/postgresql/.s.PGSQL.${toString config.services.postgresql.port} rw,
            '';
          };
        }
      ]
    else
      lib.mkMerge [ { b3scalenoded = commonService; }
      {
        b3scalenoded = {
          apparmor.extraConfig = ''
            /run/bbb-web/bigbluebutton.properties r,
            deny /etc/passwd r,

            deny network netlink raw,
            deny network udp,
          '';

          environment = {
            B3SCALE_LOAD_FACTOR = cfg.loadFactor;
          };

          script = ''
            set -eu
            export B3SCALE_DB_URL="user=b3scale host=${cfg.master}.wg dbname=b3scale password=$(cat /run/secrets/b3scale/dbpass)"
            exec ${pkgs.b3scale}/bin/b3scalenoded -register
          '';

          serviceConfig = {
            SupplementaryGroups = "bbb-web";
          };
        };
      }
    ];

    users.users.b3scale = {
      description = "b3scale user";
      isSystemUser = true;
      group = "b3scale";
    };
    users.groups.b3scale = {};

    helsinki.cooler-postgresql = lib.mkIf (isMaster && cfg.configureDB) {
      enable = true;

      ensureRoles.b3scale.passwordFile = "/run/secrets/b3scale/dbpass";

      ensureDatabases.b3scale = {
        extensions = [ "uuid-ossp" ];
        owner = "b3scale";
        roles = [ "b3scale" ];
      };
    };

    services.postgresql = lib.mkIf (isMaster && cfg.configureDB) {
      authentication = ''
        local b3scale b3scale ident
        ${lib.concatMapStringsSep "\n" (b: "host b3scale b3scale ${b}.wg scram-sha-256") cfg.backends}
      '';

      enableTCPIP = true;
    };

    helsinki.firewall.ports.tcp = lib.mkIf (isMaster && cfg.configureDB) [{
      ports = [ 5432 ];
      saddrs = backendAddrs;
    }];

    environment.systemPackages = [ pkgs.b3scale ];
  });
}
