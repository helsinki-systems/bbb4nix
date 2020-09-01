{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.web;
  bbbLib = import ./lib.nix { inherit pkgs lib; };

  bbbProperties = pkgs.writeText "bigbluebutton.properties" ((concatStringsSep "\n" (mapAttrsToList (n: v: "${n}=${toString v}") cfg.config)) + "\n");
  applicationConf = bbbLib.mkHoconFile "bbb-web-akka.conf" cfg.akkaConfig;
  # Default config: https://github.com/bigbluebutton/bigbluebutton/blob/develop/bigbluebutton-web/grails-app/conf/spring/turn-stun-servers.xml
  turnStunServers = toString (pkgs.writeText "turn-stun-servers.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-2.5.xsd">

      ${concatStringsSep "\n" (imap1 (n: v: ''
        <bean id="stun${toString n}" class="org.bigbluebutton.web.services.turn.StunServer">
          <constructor-arg index="0" value="${v}"/>
        </bean>
      '') cfg.stunServers)}

      ${concatStringsSep "\n" (imap1 (n: v: ''
        <bean id="iceCandidate${toString n}" class="org.bigbluebutton.web.services.turn.RemoteIceCandidate">
          <constructor-arg index="0" value="${v}"/>
        </bean>
      '') cfg.iceCandidates)}

      ${concatStringsSep "\n" (imap1 (n: v: ''
        <bean id="turn${toString n}" class="org.bigbluebutton.web.services.turn.TurnServer">
          <constructor-arg index="0" value="@TURN_SECRET_${toString n}@"/>
          <constructor-arg index="1" value="${v.url}"/>
          <constructor-arg index="2" value="${toString v.secretTTL}"/>
        </bean>
      '') cfg.turnServers)}

      <bean id="stunTurnService" class="org.bigbluebutton.web.services.turn.StunTurnService">
        <property name="stunServers">
          <set>
            ${concatMapStringsSep "\n" (n: ''<ref bean="stun${toString n}"/>'') (range 1 (length cfg.stunServers))}
          </set>
        </property>
        <property name="remoteIceCandidates">
          <set>
            ${concatMapStringsSep "\n" (n: ''<ref bean="iceCandidate${toString n}"/>'') (range 1 (length cfg.iceCandidates))}
          </set>
        </property>
        <property name="turnServers">
          <set>
            ${concatMapStringsSep "\n" (n: ''<ref bean="turn${toString n}"/>'') (range 1 (length cfg.turnServers))}
          </set>
        </property>
      </bean>
    </beans>
  '');
  pkg = pkgs.bbbPackages.web.override {
    turnStunServers = "file:/run/bbb-web/turn-stun-servers.xml";
  };
in {
  options.services.bigbluebutton.web = with types; {
    enable = mkEnableOption "the BigBlueButton core web component";

    config = mkOption {
      description = "Extra config overrides for bbb-web";
      type = attrsOf (oneOf [ int str bool ]);
      default = {};
    };

    akkaConfig = mkOption {
      description = "Extra config for AKKA";
      type = bbbLib.hoconType;
      default = {};
    };

    port = mkOption {
      description = "Port to listen on";
      type = port;
      default = 8090;
    };

    extraArgs = mkOption {
      description = "Extra options to pass to bbb-web";
      type = listOf str;
      default = [];
    };

    stunServers = mkOption {
      description = "List of STUN servers to configure";
      type = listOf str;
      default = [ "stun:stun.freeswitch.org" ];
    };

    iceCandidates = mkOption {
      description = "List of ICE candidates to configure";
      type = listOf str;
      default = [];
    };

    turnServers = mkOption {
      description = ''
        List of TURN servers to configure.

        The secrets are read from /var/lib/secrets/bigbluebutton/bbb-web-turn with
        one secret per line in the same order they are set here.
      '';
      default = [];
      type = listOf (submodule ({ ... }: {
        options = {
          url = mkOption {
            description = "URL of this TURN server";
            type = str;
            example = "turn:turn1.example.com";
          };

          secretTTL = mkOption {
            description = "Time-To-Live for the TURN secret in seconds";
            type = ints.unsigned;
            default = 86400;
          };
        };
      }));
    };
  };

  config = mkIf cfg.enable {
    systemd.services.bbb-web = {
      description = "the BigBlueButton web component";
      wantedBy = [ "bigbluebutton.target" ];

      path = with pkgs; [
        poppler_utils # pdfinfo as in bbb-common-web/src/main/java/org/bigbluebutton/presentation/imp/PdfPageCounter.java:43
        imagemagick # `convert` is sarched in $PATH (also specified in the config later, but we need both)
        gnugrep
        ghostscript # bbb-common-web/src/main/java/org/bigbluebutton/presentation/imp/PdfPageDownscaler.java
      ];

      preStart = ''
        # for each line in our properties, check if it exists in the defaults and if it does, replace it. if it doesn't, just append it
        cat ${pkg}/share/bbb-web/WEB-INF/classes/bigbluebutton.properties > /run/bbb-web/bigbluebutton.properties
        cat ${bbbProperties} /var/lib/secrets/bigbluebutton/bbb-web.properties | while read -r l; do
          name=$(cut -d= -f1 <<< "$l")
          value=$(cut -d= -f2- <<< "$l")
          existing=$(grep "^''${name}=" /run/bbb-web/bigbluebutton.properties)
          if [[ "$existing" != "" ]]; then
            sed -i "s|^$name=.*$|$l|" /run/bbb-web/bigbluebutton.properties
          else
            echo "$l" >> /run/bbb-web/bigbluebutton.properties
          fi
        done

        # TURN/STUN secrets
        cat ${turnStunServers} > /run/bbb-web/turn-stun-servers.xml
        i=1
        while IFS= read -r line; do
          sed -i "s@TURN_SECRET_''${i}@''${line}g" /run/bbb-web/turn-stun-servers.xml
          i=$((++i))
        done < /var/lib/secrets/bigbluebutton/bbb-web-turn

        # AKKA config
        get() {
          grep "^$1" /run/bbb-web/bigbluebutton.properties | cut -d= -f2- | tail -1
        }

        sed \
          -e "s/@REDIS_HOST@/$(get redisHost)/g" \
          -e "s/@REDIS_PORT@/$(get redisPort)/g" \
          -e "s/@REDIS_PW@/$(get redisPassword)/g" \
          -e "s/@REDIS_EXPIRY@/$(get redisExpiry)/g" \
          ${applicationConf} > /run/bbb-web/application.conf

        mkdir -p /tmp/empty
      '';

      sandbox = 2;
      serviceConfig = {
        ExecStart = "${pkg}/bin/bbb-web -Dserver.port=${toString cfg.port} -Dbbb-web.config.location=/run/bbb-web/bigbluebutton.properties -Dconfig.file=/run/bbb-web/application.conf ${escapeShellArgs cfg.extraArgs}";
        Restart = "on-failure";

        ReadWritePaths = [ "/var/lib/bigbluebutton" "/var/lib/bigbluebutton-soffice" ];
        RuntimeDirectory = "bbb-web";
        RuntimeDirectoryMode = "0700";

        User = "bbb-web";
        SupplementaryGroups = "bbb-soffice";

        PrivateNetwork = false;
        UMask = "0007";
        MemoryDenyWriteExecute = false;
      };

      apparmor.extraConfig = ''
        /var/lib/secrets/bigbluebutton/bbb-web-akka.conf r,
        /var/lib/secrets/bigbluebutton/bbb-web.properties r,
        /var/lib/secrets/bigbluebutton/bbb-web-turn r,
        @{PROC}@{pid}/fd/ r,
        deny @{PROC}@{pid}/mounts r,
        deny @{PROC}@{pid}/mounts r,
        deny @{PROC}/sys/net/core/somaxconn r,

        network unix stream,
        network inet dgram,
        network inet stream,
        network inet6 dgram,
        network inet6 stream,
      '';
    };

    services.bigbluebutton.web.config = {
      # Tool paths
      imageMagickDir = "${pkgs.imagemagick}/bin";
      # /var/bigbluebutton -> /var/lib/bigbluebutton
      presentationDir = "/var/lib/bigbluebutton";
      recordStatusDir = "/var/lib/bigbluebutton/recording/status/recorded";
      publishedDir = "/var/lib/bigbluebutton/published";
      unpublishedDir = "/var/lib/bigbluebutton/unpublished";
      captionsDir = "/var/lib/bigbluebutton/captions";
      # soffice
      sofficeWorkingDirBase = "/var/lib/bigbluebutton-soffice/";
      sofficePortBase = config.services.bigbluebutton.soffice.portBase;
      sofficeManagers = config.services.bigbluebutton.soffice.workers;
      # Blank files
      BLANK_PRESENTATION = "${pkgs.bbbPackages.blankSlides}/blank-presentation.pdf";
      BLANK_THUMBNAIL = "${pkgs.bbbPackages.blankSlides}/blank-thumb.png";
      BLANK_PNG = "${pkgs.bbbPackages.blankSlides}/blank-png.png";
      BLANK_SVG = "${pkgs.bbbPackages.blankSlides}/blank-svg.svg";
      # Disable Flash
      configDir = "/tmp/empty"; # Configs for the Flash client
      attendeesJoinViaHTML5Client = true;
      moderatorsJoinViaHTML5Client = true;
    };

    services.bigbluebutton.web.akkaConfig = {
      akka = {
        actor.debug = {
          autoreceive = mkDefault true;
          lifecycle = mkDefault true;
        };
        loggers = mkDefault [ "akka.event.slf4j.Slf4jLogger" ];
        loglevel = mkDefault "DEBUG";
        redis-publish-worker-dispatcher = {
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

      # Filled from bigbluebutton.properties
      redis = {
        host = "@REDIS_HOST@";
        port = "@REDIS_PORT@";
        password = "@REDIS_PW@";
        # recording keys should expire in 14 days
        keyExpiry = "@REDIS_EXPIRY@";
      };

      eventBus = {
        meetingManagerChannel = mkDefault "MeetingManagerChannel";
        outMessageChannel = mkDefault "OutgoingMessageChannel";
        incomingJsonMsgChannel = mkDefault "IncomingJsonMsgChannel";
        outBbbMsgMsgChannel = mkDefault "OutBbbMsgChannel";
      };
    };

    systemd.tmpfiles.rules = [
      "f /var/lib/secrets/bigbluebutton/bbb-web-akka.conf 0400 bbb-web nogroup -"
      "f /var/lib/secrets/bigbluebutton/bbb-web.properties 0400 bbb-web nogroup -"
      "f /var/lib/secrets/bigbluebutton/bbb-web-turn 0400 bbb-web nogroup -"
      "d /var/lib/bigbluebutton 2755 bbb-web nginx -"
      "d /var/lib/bigbluebutton/unpublished 0755 bbb-web nogroup -"
      "d /var/lib/bigbluebutton/published 2750 bbb-web nginx -"
      "d /var/lib/bigbluebutton/recording 0700 bbb-web nogroup -"
      "d /var/lib/bigbluebutton/recording/status 0700 bbb-web nogroup -"
      "d /var/lib/bigbluebutton/recording/status/recorded 0700 bbb-web nogroup -"
    ];

    services.bigbluebutton.soffice.enable = true;

    users.users.bbb-web = {
      description = "BigBlueButton web user";
      isSystemUser = true;
    };
  };
}
