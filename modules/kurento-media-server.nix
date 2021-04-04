{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.kurento-media-server;
in {
  options.services.bigbluebutton.kurento-media-server = with types; {
    enable = mkEnableOption "Kurento Media Server and configure it for BigBlueButton";

    port = mkOption {
      description = "Port to listen on";
      type = port;
      default = 8888;
    };

    threads = mkOption {
      description = "Number of threads to listen with";
      type = ints.unsigned;
      default = 10;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.kurento-media-server = {
      wantedBy = mkForce [ "bigbluebutton.target" ];
      partOf = [ "bigbluebutton.target" ];
    };
    services.kurento-media-server = {
      enable = true;
      mediaServerConfig = {
        resources = {
          garbageCollectorPeriod = 240;
          disableRequestCache = false;
        };
        net.websocket = {
          inherit (cfg) port threads;
          path = "kurento";
        };
      };

      iniModuleConfigs.BaseRtpEndpoint = {
        minPort = 24577;
        maxPort = 32768;
      };

      jsonModuleConfigs.SdpEndpoint = {
        numAudioMedias = 1;
        numVideoMedias = 1;
        audioCodecs = [
          { name = "opus/48000/2"; }
          { name = "PCMU/8000"; }
          { name = "AMR/8000"; }
        ];
        videoCodecs = [
          { name = "VP8/90000"; }
          { name = "H264/90000"; }
        ];
      };
    };
  };
}
