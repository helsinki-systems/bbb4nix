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
      stopIfChanged = false;
      sandbox = 2;
      wantedBy = mkForce [ "bigbluebutton.target" ];
      partOf = [ "bigbluebutton.target" ];
      serviceConfig = {
        Group = lib.mkForce "bbb-turn";
        SystemCallFilter = "@system-service";
        PrivateNetwork = false;
        PrivateUsers = false;
      };
      apparmor = {
        enable = true;
        extraConfig = ''
          ${config.services.coturn.pkey} r,
          ${config.services.coturn.cert} r,

          /var/lib/secrets/bigbluebutton/bbb-web-turn r,
          deny /var/tmp/** rw,

          network udp,
          network tcp,
        '';
      };
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
