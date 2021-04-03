{ config, lib, ... }: with lib;
let
  cfg = config.services.bigbluebutton.redis;
in {
  options.services.bigbluebutton.redis = {
    enable = mkEnableOption "redis instance for BBB";
  };

  config = mkIf cfg.enable {
    helsinki.cooler-redis = {
      instances.bigbluebutton.extraConfig = {
        tcp-keepalive = 0;
        save = [
          "900 1"
          "300 10"
          "60 10000"
        ];
      };
      disableHugepages = true;
      vmOverCommit = true;
    };

    systemd.services.redis-bigbluebutton.serviceConfig = {
      PrivateNetwork = false;
    };
  };
}
