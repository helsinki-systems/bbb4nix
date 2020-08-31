{ config, lib, ... }: with lib; let
  cfg = config.services.bigbluebutton.coturn;
in {
  options.services.bigbluebutton.coturn = {
    enable = mkEnableOption "the coturn STUN/TURN server and configure it for BigBlueButton";
  };

  config = mkIf cfg.enable {
    services.bigbluebutton.web = {
      stunServers = [ "stun:${config.services.bigbluebutton.simple.domain}" ];

      turnServers = [{
        url = "turn:${config.services.bigbluebutton.simple.domain}";
      }];
    };

    services.coturn = {
      enable = true;
      lt-cred-mech = true;
      use-auth-secret = true;
      realm = mkDefault config.services.bigbluebutton.simple.domain;
      relay-ips = mkDefault config.services.bigbluebutton.simple.ips;
      listening-port = 3478;
      tls-listening-port = 5349;
      # TODO Replace static auth secret
      extraConfig = ''
        fingerprint

        no-tlsv1
        no-tlsv1_1
      '';
      extraParams = mkDefault "${concatMapStringsSep " " (x: "--listening-ip ${x}") config.services.bigbluebutton.simple.ips} -v";
      cert = "/var/lib/acme/${config.services.bigbluebutton.simple.domain}/fullchain.pem"; # TODO if acme enabled
      pkey = "/var/lib/acme/${config.services.bigbluebutton.simple.domain}/key.pem";
    };

    systemd.services.coturn = {
      sandbox = 1;
      serviceConfig = {
        SystemCallFilter = "@system-service";
        PrivateNetwork = false;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        PrivateUsers = false;
      };
      apparmor.extraConfig = ''
        ${config.services.coturn.pkey} r,
        ${config.services.coturn.cert} r,

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
  };
}
