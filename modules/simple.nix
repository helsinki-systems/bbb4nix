{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.simple;
in {
  options.services.bigbluebutton.simple = with types; {
    enable = mkEnableOption "a simple one-node BigBlueButton installation";

    domain = mkOption {
      description = "Domain under which to serve this BigBlueButton";
      type = str;
      example = "bbb.example.com";
    };

    ips = mkOption {
      description = "List of IP addresses this BigBlueButton is served on";
      type = listOf str;
      default = [];
      example = [ "1.1.1.1" "8.8.8.8" ];
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
        stunServers = [ "stun:${cfg.domain}" ];
        turnServers = [
          { url = "turn:${cfg.domain}?transport=tcp"; }
          { url = "turns:${cfg.domain}?transport=tcp"; }
        ];
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
      webrtc-sfu = {
        enable = true;
        myIP = head cfg.ips;
      };
      mongodb.enable = true;
      redis.enable = true;
      nginx = {
        enable = true;
        domain = cfg.domain;

        etherpadUrl = "http://127.0.0.1:9001";
        freeswitchVertoUrl = "http://127.0.0.1:8082";
        freeswitchWsUrl = "https://${cfg.domain}:${toString config.services.bigbluebutton.freeswitch.wssPort}";
        greenlightUrl = "http://127.0.0.1:${toString config.services.bigbluebutton.greenlight.port}";
        html5Url = "http://127.0.0.1:${toString config.services.bigbluebutton.html5.port}";
        webUrl = "http://127.0.0.1:${toString config.services.bigbluebutton.web.port}";
        webrtcSfuUrl = "http://127.0.0.1:${toString config.services.bigbluebutton.webrtc-sfu.port}";
      };
      coturn = {
        enable = true;
      };
      acme.enable = true;
    };

    services.coturn = {
      realm = cfg.domain;
      relay-ips = cfg.ips;
      extraParams = "${concatMapStringsSep " " (x: "--listening-ip ${x}") cfg.ips} -v";
      cert = "/var/lib/acme/${cfg.domain}/fullchain.pem";
      pkey = "/var/lib/acme/${cfg.domain}/key.pem";
    };

    environment.systemPackages = with pkgs; with bbbPackages; [
      generateSecrets
    ];
  };
}
