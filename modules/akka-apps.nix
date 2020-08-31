{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.akka-apps;
  bbbLib = import ./lib.nix { inherit pkgs lib; };

  configFile = bbbLib.mkHoconFile "bbb-akka-apps.conf" cfg.config;
in {
  options.services.bigbluebutton.akka-apps = with types; {
    enable = mkEnableOption "the Apps component";

    config = mkOption {
      description = "Apps configuration. This will be merged with the configuration from /var/lib/secrets/bigbluebutton/bbb-akka-apps.conf.";
      default = {};
      type = bbbLib.hoconType;
    };
  };

  config = mkIf cfg.enable {
    services.bigbluebutton.akka-apps.config = {
      akka = {
        loggers = mkDefault [ "akka.event.slf4j.Slf4jLogger" ];
        loglevel = mkDefault "DEBUG";
        stdout-loglevel = mkDefault "DEBUG";
        redis-publush-worker-dispatcher = {
          mailbox-type = mkDefault "akka.dispatch.SingleConsumerOnlyUnboundedMailbox";
          # Throughput defines the maximum number of messages to be
          # processed per actor before the thread jumps to the next actor.
          # Set to 1 for as fair as possible.
          throughput = mkDefault 512;
        };
        redis-subscriber-worker-dispatcher = {
          mailbox-type = mkDefault "akka.dispatch.SingleConsumerOnlyUnboundedMailbox";
          # Throughput defines the maximum number of messages to be
          # processed per actor before the thread jumps to the next actor.
          # Set to 1 for as fair as possible.
          throughput = mkDefault 512;
        };
      };

      redis = {
        host = mkDefault "127.0.0.1";
        port = mkDefault 6379;
        password = mkDefault "";
        # recording keys should expire in 14 days
        keyExpiry = mkDefault 1209600;
      };

      expire = {
        # time in seconds
        lastUserLeft = mkDefault 60;
        neverJoined = mkDefault 300;
        maxRegUserToJoin = mkDefault 300;
      };

      services = {
        bbbWebAPI = mkDefault "http://192.168.23.33/bigbluebutton/api";
        sharedSecret = mkDefault "changeme";
      };

      eventBus = {
        meetingManagerChannel = mkDefault "MeetingManagerChannel";
        outMessageChannel = mkDefault "OutgoingMessageChannel";
        incomingJsonMsgChannel = mkDefault "IncomingJsonMsgChannel";
        outBbbMsgMsgChannel = mkDefault "OutBbbMsgChannel";
      };

      sharedNotes = {
        maxNumberOfNotes = mkDefault 3;
        maxNumberOfUndos = mkDefault 30;
      };

      http = {
        interface = mkDefault "127.0.0.1";
        port = mkDefault 9999;
      };

      apps = {
        checkPermissions = mkDefault true;
        endMeetingWhenNoMoreAuthedUsers = mkDefault false;
        endMeetingWhenNoMoreAuthedUsersAfterMinutes = mkDefault 2;
      };

      voiceConf = {
        recordPath = "/var/lib/freeswitch/meetings";
        recordCodec = mkDefault "opus";
        # Interval seconds to check if FreeSWITCH is recording.
        checkRecordingInterval = mkDefault 23;
        # Interval seconds to sync voice users status.
        syncUserStatusInterval = mkDefault 41;
      };

      recording.chapterBreakLengthInMinutes = mkDefault 0;
      whiteboard.multiUserDefault = mkDefault false;
    };

    systemd.services.bbb-akka-apps = rec {
      description = "BigBlueButton Apps";
      wantedBy = [ "bigbluebutton.target" ];
      wants = [ "freeswitch.service" ];

      path = with pkgs; [ gawk openjdk8 ];

      sandbox = 2;
      serviceConfig = {
        ExecStart = "${pkgs.bbbPackages.akkaApps}/bin/bbb-apps-akka -Dconfig.file=${configFile}";
        Restart = "on-failure";
        WorkingDirectory = pkgs.bbbPackages.akkaApps;

        ReadOnlyPaths = [ "/var/lib/secrets/bigbluebutton/bbb-akka-apps.conf" ];
        User = "bbb-akka-apps";

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
      "f /var/lib/secrets/bigbluebutton/bbb-akka-apps.conf 0400 bbb-akka-apps nogroup -"
    ];

    users.users.bbb-akka-apps = {
      description = "BigBlueButton AKKA Apps user";
      isSystemUser = true;
    };
  };
}
