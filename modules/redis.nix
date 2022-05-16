{ config, lib, ... }: with lib;
let
  cfg = config.services.bigbluebutton.redis;
in {
  options.services.bigbluebutton.redis = {
    enable = mkEnableOption "redis instance for BBB";
  };

  config = mkIf cfg.enable {
    services.redis = {
      vmOverCommit = true;
      servers.bigbluebutton = {
        enable = true;
        settings.tcp-keepalive = 0;
        save = [
          [ 900 1 ]
          [ 300 10 ]
          [ 60 10000 ]
        ];
      };
    };

    systemd.services.redis-bigbluebutton = {
      serviceConfig.PrivateNetwork = false;
      wantedBy = mkForce [ "bigbluebutton.target" ];
      partOf = [ "bigbluebutton.target" ];
    };
  };
}
