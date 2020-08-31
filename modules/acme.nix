{ config, lib, ... }: with lib; let
  cfg = config.services.bigbluebutton.acme;
in {
  options.services.bigbluebutton.acme = {
    enable = mkEnableOption "an ACME cert fo this BBB instance and configure it accordingly";
  };

  config = mkIf cfg.enable {
    security.acme.certs."${config.services.bigbluebutton.simple.domain}" = {
      allowKeysForGroup = true;
      group = "acme-bbb";
    };

    users.groups.acme-bbb.members = [ "turnserver" ]; # TODO: if coturn enabled

    services.nginx.virtualHosts."${config.services.bigbluebutton.nginx.virtualHost}" = {
      enableACME = true;
      forceSSL = true;
    };
  };
}
