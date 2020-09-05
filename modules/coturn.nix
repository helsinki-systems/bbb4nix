{ config, lib, ... }: with lib; let
  cfg = config.services.bigbluebutton.coturn;
in {
  options.services.bigbluebutton.coturn = {
    enable = mkEnableOption "the coturn STUN/TURN server and configure it for BigBlueButton";
  };

  config = mkIf cfg.enable {
    services.coturn = {
      enable = true;
      lt-cred-mech = true;
      use-auth-secret = true;
      listening-port = 3478;
      tls-listening-port = 5349;
      extraConfig = ''
        fingerprint

        no-tlsv1
        no-tlsv1_1
      '';
      staticAuthSecretFile = "/var/lib/secrets/bigbluebutton/bbb-web-turn";
    };

    systemd.services.coturn = {
      sandbox = 2;
      serviceConfig = {
        Group = lib.mkForce "bbb-turn";
        SystemCallFilter = "@system-service";
        PrivateNetwork = false;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        PrivateUsers = false;
      };
      apparmor.extraConfig = ''
        ${config.services.coturn.pkey} r,
        ${config.services.coturn.cert} r,

        /var/lib/secrets/bigbluebutton/bbb-web-turn r,

        network unix dgram,
        network inet dgram,
        network inet stream,
        network inet6 dgram,
        network inet6 stream,
      '';
    };

    helsinki.firewall.ports = {
      multi = [
        "3478-3479" # Listening ports
        "5349-5350" # TLS listening ports
      ];
      udp = [
        "49152-65535"
      ];
    };

    users.groups.bbb-turn = {};
  };
}
