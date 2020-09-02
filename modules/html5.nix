{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.html5;
  bbbLib = import ./lib.nix { inherit pkgs lib; };
in {
  options.services.bigbluebutton.html5 = with types; {
    enable = mkEnableOption "the HTML5 component";

    port = mkOption {
      description = "Port to listen on";
      type = port;
      default = 3000;
    };

    mongoUrl = mkOption {
      description = "MongoDB URL";
      type = str;
      default = "mongodb://127.0.1.1/meteor";
    };

    rootUrl = mkOption {
      description = "Root URL";
      type = str;
    };

    config = mkOption {
      type = bbbLib.jsonType;
      description = "Config overrides, are merged with defaults";
      example = {};
    };
  };

  config = mkIf cfg.enable {
    systemd.services.bbb-html5 = let
      configJson = pkgs.writeText "bbb-html5-settings.json" (builtins.toJSON cfg.config);
    in {
      description = "the BigBlueButton html5 component";
      wantedBy = [ "bigbluebutton.target" ];

      path = with pkgs; [ glibc.bin ];

      preStart = ''
        # merge defaults and custom config
        ETHERPAD_APIKEY=$(cat ${config.services.bigbluebutton.etherpad-lite.apiKeyFile})
        echo '{ "private": { "etherpad": { "apikey": "'"$ETHERPAD_APIKEY"'" } } }' > /run/bbb-html5/etherpad.json
        ${pkgs.yq}/bin/yq . ${pkgs.bbbPackages.html5-unwrapped}/programs/server/assets/app/config/settings.yml > /run/bbb-html5/defaults.json
        ${pkgs.jq}/bin/jq -s '.[0] * .[1] * .[2]' /run/bbb-html5/defaults.json /run/bbb-html5/etherpad.json ${configJson} > /run/bbb-html5/settings.json
      '';

      sandbox = 2;
      apparmor = {
        extraConfig = ''
          network inet stream,
          network unix stream,
          /var/lib/bbb-etherpad-lite/APIKEY r,
        '';
      };

      serviceConfig = {
        User = "bbb-html5";
        SupplementaryGroups = "bbb-etherpad-lite";

        ExecStart = "${pkgs.bbbPackages.html5}/bin/bbb-html5";

        RuntimeDirectory = "bbb-html5";

        PrivateNetwork = false;
        MemoryDenyWriteExecute = false;
      };
    };

    users.users.bbb-html5 = {
      description = "BigBlueButton html5 user";
      isSystemUser = true;
    };
  };
}
