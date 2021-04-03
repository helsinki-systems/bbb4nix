{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.greenlight;
  rubyEnv = pkgs.bbbPackages.greenlight + "/env";
  secretEnv = "/var/lib/secrets/bbb-greenlight/env";
  path = with pkgs; [ rubyEnv nodejs coreutils gnugrep ];
in {
  options.services.bigbluebutton.greenlight = with types; {
    enable = mkEnableOption "the BBB greenlight service";

    port = mkOption {
      description = "Port to listen on";
      type = port;
      default = 8000;
    };

    bbbEndpoint = mkOption {
      description = "Endpoint to connect to for BBB.";
      type = str;
    };

    adminName = mkOption {
      description = "Name of the admin user. May contain spaces.";
      type = str;
    };

    adminEmail = mkOption {
      description = "Email address of admin user.";
      type = str;
    };

    environment = mkOption {
      description = "Environment variables, merged with defaults for systemd service";
      type = attrsOf (nullOr (oneOf [ str path package ]));
      default = {};
    };
  };

  config = mkIf cfg.enable {
    systemd.services.bbb-greenlight = {
      environment = {
        # for bundler
        HOME = "/var/lib/bbb-greenlight/home";
        # general settings
        RAILS_ENV = "production";
        PATH = mkForce "${lib.makeBinPath path}";
        GEM_PATH = "${rubyEnv}/lib/ruby/gems";

        # greenlight config starts here
        BIGBLUEBUTTON_ENDPOINT = cfg.bbbEndpoint;

        ALLOW_GREENLIGHT_ACCOUNTS = "true";
        DEFAULT_REGISTRATION = "approval";

        ALLOW_MAIL_NOTIFICATIONS = "true";

        RELATIVE_URL_ROOT = "/b";

        ROOM_FEATURES = "mute-on-join,anyone-can-start,all-join-moderator";

        ENABLE_GOOGLE_CALENDAR_BUTTON = "false";

        MAINTENANCE_MODE = "false";

        # MAINTENANCE_WINDOW = Friday August 18 6pm-10pm EST

        REPORT_ISSUE_URL = "";

        RAILS_LOG_TO_STDOUT = "true";

        ENABLE_SSL = "true";

        DB_ADAPTER = "postgresql";
        DB_HOST = "127.0.0.1";
        DB_NAME = "greenlight";
        DB_USERNAME = "greenlight";

        PORT = toString cfg.port;
      } // cfg.environment;

      script = ''
        set -eu
        source '${secretEnv}'
        # running db:schema:load on first startup would be more elegant, but migrate works on first and any other startup
        bundle exec rake db:migrate
        # create admin account
        bundle exec rake user:create["${cfg.adminName}","${cfg.adminEmail}","$ADMIN_PASSWORD","admin"] | grep -vi password
        exec bundle exec puma -C config/puma.rb
      '';

      sandbox = 2;
      serviceConfig = {
        StateDirectory = [ "bbb-greenlight/" "bbb-greenlight/tmp/" "bbb-greenlight/log/" "bbb-greenlight/home/" ];
        RuntimeDirectory = [ "bbb-greenlight/tmp" "bbb-greenlight/log" ];
        WorkingDirectory = pkgs.bbbPackages.greenlight;
        User = "greenlight";

        PrivateNetwork = false;
        PrivateUsers = false;
        MemoryDenyWriteExecute = false;
        SystemCallFilter = "@system-service";
      };
      apparmor.packages = path;
      apparmor.extraConfig = ''
        ${secretEnv} r,
        @{PROC}@{pid}/task/@{pid}/comm rw,
        deny /etc/passwd r,

        deny network netlink raw,
        network unix stream,
        network inet dgram,
        network inet stream,
        network inet6 dgram,
        network inet6 stream,
      '';
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
      wantedBy = [ "bigbluebutton.target" ];
      partOf = [ "bigbluebutton.target" ];
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/secrets/bbb-greenlight 0750 greenlight root -"
      "f ${secretEnv} 0640 greenlight root -"
    ];

    users.users."greenlight".isSystemUser = true;

    environment.systemPackages = [ pkgs.bbbPackages.greenlight-bundle ];

    helsinki.cooler-postgresql = {
      enable = true;

      ensureDatabases = {
        greenlight = {
          owner = "greenlight";
          roles = [ "greenlight" ];
        };
      };

      ensureRoles = {
        greenlight = {
          passwordFile = secretEnv;
          passwordFileRegex = "(?<=DB_PASSWORD=).+$";
        };
      };
    };
  };
}
