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
      default = "https://${config.services.bigbluebutton.simple.domain}/html5client";
    };

    config = mkOption {
      type = bbbLib.jsonType;
      description = "Config overrides, are merged with defaults";
      example = {};
      default = {
        public = {
          kurento = {
            wsUrl = "wss://${config.services.bigbluebutton.simple.domain}/bbb-webrtc-sfu";
          };
        };
      };
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
        ${pkgs.yq}/bin/yq . ${pkgs.bbbPackages.html5-unwrapped}/programs/server/assets/app/config/settings.yml > /run/bbb-html5/defaults.json
        cat /run/bbb-html5/defaults.json ${configJson} | ${pkgs.jq}/bin/jq -s '.[0] * .[1]' > /run/bbb-html5/settings.json
      '';

      serviceConfig = {
        ExecStart = "${pkgs.bbbPackages.html5}/bin/bbb-html5";

        RuntimeDirectory = "bbb-html5";

        User = "bbb-html5";
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
