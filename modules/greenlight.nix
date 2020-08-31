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

    bbbDomain = mkOption {
      description = "Domain to connect to as BBB endpoint.";
      type = str;
      default = config.services.bigbluebutton.simple.domain;
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
        BIGBLUEBUTTON_ENDPOINT = "https://${cfg.bbbDomain}/";

        ALLOW_GREENLIGHT_ACCOUNTS = "true";
        DEFAULT_REGISTRATION = "approval";

        ALLOW_MAIL_NOTIFICATIONS = "true";
        SMTP_SERVER = "smtp.helsinki.tools";
        SMTP_PORT = "587";
        SMTP_DOMAIN = "helsinki-systems.de";
        SMTP_USERNAME = "bigbluebutton@helsinki-systems.de";
        SMTP_AUTH = "plain";
        SMTP_STARTTLS_AUTO = "true";
        SMTP_SENDER = "Big Blue Button <bigbluebutton@helsinki-systems.de>";

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
      };

      script = ''
        set -eu
        source '${secretEnv}'
        # running db:schema:load on first startup would be more elegant, but migrate works on first and any other startup
        bundle exec rake db:migrate
        # create admin account
        bundle exec rake user:create["Helsinki Systems","bbb-admin@helsinki-systems.de","$ADMIN_PASSWORD","admin"] | grep -vi password
        exec bundle exec puma -C config/puma.rb
      '';

      sandbox = 1;
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
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/secrets/bbb-greenlight 0750 greenlight root -"
      "f ${secretEnv} 0640 greenlight root -"
    ];

    users.users."greenlight".isSystemUser = true;

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
          createDatabases = true;
        };
      };
    };
  };
}
