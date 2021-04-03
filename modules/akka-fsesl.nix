{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.akka-fsesl;
  bbbLib = import ./lib.nix { inherit pkgs lib; };

  configFile = bbbLib.mkHoconFile "bbb-akka-fsesl.conf" cfg.config;
in {
  options.services.bigbluebutton.akka-fsesl = with types; {
    enable = mkEnableOption "the FSESL component";

    config = mkOption {
      description = "FSESL configuration. This will be merged with the configuration from /var/lib/secrets/bigbluebutton/bbb-akka-fsesl.conf.";
      default = {};
      type = bbbLib.hoconType;
    };
  };

  config = mkIf cfg.enable {
    services.bigbluebutton.akka-fsesl.config = {
      akka = {
        actor.debug.receive = mkDefault true;
        loggers = mkDefault [ "akka.event.slf4j.Slf4jLogger" ];
        loglevel = mkDefault "DEBUG";
        stdout-loglevel = mkDefault "DEBUG";
        redis-subscriber-worker-dispatcher = {
          mailbox-type = mkDefault "akka.dispatch.SingleConsumerOnlyUnboundedMailbox";
          # Throughput defines the maximum number of messages to be
          # processed per actor before the thread jumps to the next actor.
          # Set to 1 for as fair as possible.
          throughput = mkDefault 512;
        };
      };

      freeswitch = {
        esl = {
          host = mkDefault "127.0.0.1";
          port = mkDefault 8021;
          password = mkDefault "ClueCon";
        };
        conf.profile = mkDefault "cdquality";
      };

      redis = {
        host = mkDefault "127.0.0.1";
        port = mkDefault 6379;
        password = mkDefault "";
        # recording keys should expire in 14 days
        keyExpiry = mkDefault 1209600;
      };

      http = {
        interface = mkDefault "127.0.0.1";
        port = mkDefault 8900;
      };
    };

    systemd.services.bbb-akka-fsesl = rec {
      description = "BigBlueButton FSESL";
      wantedBy = [ "bigbluebutton.target" ];
      partOf = [ "bigbluebutton.target" ];
      wants = [ "freeswitch.service" ];
      stopIfChanged = false;

      path = with pkgs; [ gawk openjdk8 ];

      sandbox = 2;
      serviceConfig = {
        ExecStart = "${pkgs.bbbPackages.akkaFsesl}/bin/bbb-fsesl-akka -Dconfig.file=${configFile}";
        Restart = "on-failure";
        WorkingDirectory = pkgs.bbbPackages.akkaFsesl;

        ReadOnlyPaths = [ "/var/lib/secrets/bigbluebutton/bbb-akka-fsesl.conf" ];
        User = "bbb-akka-fsesl";

        PrivateNetwork = false;
        MemoryDenyWriteExecute = false;
      };

      apparmor = {
        packages = path;
        extraConfig = ''
          @{PROC}/sys/net/core/somaxconn r,
          @{PROC}@{pid}/net/if_inet6 r,
          @{PROC}@{pid}/net/ipv6_route r,
          deny @{PROC}/mountinfo r,
          deny @{PROC}@{pid}/task/@{pid}/comm r,

          network unix stream,
          network inet dgram,
          network inet stream,
          network inet6 dgram,
          network inet6 stream,
        '';
      };
    };

    systemd.tmpfiles.rules = [
      "f /var/lib/secrets/bigbluebutton/bbb-akka-fsesl.conf 0400 bbb-akka-fsesl nogroup -"
    ];

    users.users.bbb-akka-fsesl = {
      description = "BigBlueButton AKKA FSESL user";
      isSystemUser = true;
    };
  };
}
