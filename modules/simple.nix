{ config, lib, ... }: with lib; let
  cfg = config.services.bigbluebutton.simple;
in {
  options.services.bigbluebutton.simple = with types; {
    enable = mkEnableOption "a simple one-node BigBlueButton installation";

    domain = mkOption {
      description = "Domain under which to serve this BigBlueButton";
      type = str;
      example = "bbb.example.com";
    };
  };

  config = mkIf cfg.enable {
    services.bigbluebutton = {
      akka-fsesl.enable = true;
      akka-apps = {
        enable = true;
        config.services.bbbWebAPI = "https://${cfg.domain}/bigbluebutton/api";
      };
      web = {
        enable = true;
        config."bigbluebutton.web.serverURL" = "https://${cfg.domain}";
      };
      greenlight = {
        enable = true;
        bbbEndpoint = "https://${cfg.domain}/";
      };
      html5 = {
        enable = true;
        rootUrl = "https://${cfg.domain}/html5client";
        config = {
          public = {
            kurento.wsUrl = "wss://${cfg.domain}/bbb-webrtc-sfu";
            app.enableNetworkInformation = true;
            note = {
              enabled = true;
              url = "https://${cfg.domain}/pad";
            };
          };
        };
      };
      etherpad-lite.enable = true;
      kurento-media-server.enable = true;
      freeswitch.enable = true;
      webrtc-sfu.enable = true;
      mongodb.enable = true;
      redis.enable = true;
    };
  };
}
