{ config, lib, pkgs, ... }: with lib;
let
  bbbLib = import ./lib.nix { inherit pkgs lib; };
  cfg = config.services.bigbluebutton.etherpad-lite;

  settingsFile = pkgs.runCommand "etherpad-lite-settings.json" {
      defaultSettings = cfg.package + "/libexec/ep_etherpad-lite/deps/ep_etherpad-lite/settings.json";
    } ''
      ${pkgs.gawk}/bin/awk -f ${./remove-comments.awk} "$defaultSettings" > default_no_comments.json
      echo '${builtins.toJSON cfg.extraSettings}' > extra.json
      ${pkgs.jq}/bin/jq -s '.[0] * .[1]' default_no_comments.json extra.json > "$out"
    '';
in {

  options.services.bigbluebutton.etherpad-lite = with types; {
    enable = mkEnableOption "the BBB etherpad-lite service";

    apiKeyFile = mkOption {
      type = str;
      description = "Path to APIKEY file. If the file does not exist, it will be created.";
      default = "/var/lib/bbb-etherpad-lite/APIKEY";
    };

    sessionKeyFile = mkOption {
      type = str;
      description = "Path to SESSIONKEY file. If the file does not exist, it will be created.";
      default = "/var/lib/bbb-etherpad-lite/SESSIONKEY";
    };

    package = mkOption {
      type = package;
      description = "etherpad-lite package to use";
      default = pkgs.bbbPackages.etherpad-lite;
      defaultText = "pkgs.bbbPackages.bbb-etherpad-lite";
    };

    extraSettings = mkOption {
      type = bbbLib.jsonType;
      description = "Extra settings to merge into the default settings.json";
      default = {
        soffice = "${pkgs.libreoffice}/bin/soffice";
      };
      defaultText = ''{
        soffice = "''${pkgs.libreoffice}/bin/soffice";
      }'';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.bbb-etherpad-lite = {
      environment = {
        NODE_ENV = "production";
      };

      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${cfg.package}/bin/etherpad-lite --sessionkey ${cfg.sessionKeyFile} --apikey ${cfg.apiKeyFile} --settings ${settingsFile}";

        StateDirectory = [ "bbb-etherpad-lite" ];

        PrivateNetwork = false;
        MemoryDenyWriteExecute = false;
      };

      wantedBy = [ "bigbluebutton.target" ];
    };
  };
}
