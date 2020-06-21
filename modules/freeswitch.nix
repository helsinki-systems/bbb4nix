{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.freeswitch;

in {
  options.services.bigbluebutton.freeswitch = with types; {
    enable = mkEnableOption "FreeSWITCH and configure it for BigBlueButton";

    publicIP = mkOption {
      description = "Public IP of this machine. Set to null to use the autodiscovery provided by FreeSWITCH";
      type = nullOr str;
      default = null;
    };

    loglevel = mkOption {
      description = "Log level to set";
      type = enum [ "emerg" "alert" "crit" "err" "warning" "notice" "info" "debug" ];
      default = "warning";
    };

    eventsPort = mkOption {
      description = "Port of the events socket (used by SFU and FSESL)";
      type = port;
      default = 8021;
    };

    wssPort = mkOption {
      description = "Port of the WebSocket secure socket (used by nginx)";
      type = port;
      default = 7443;
    };

    rtpMinPort = mkOption {
      description = "Minimum RTP port to use (must be open in firewall)";
      type = port;
      default = 16384;
    };

    rtpMaxPort = mkOption {
      description = "Maximum RTP port to use (must be open in firewall)";
      type = port;
      default = 24576;
    };

    mutedUnmutedSounds = mkOption {
      description = "Whether to enable the muted/unmuted sounds";
      type = bool;
      default = true;
    };

    aloneMusic = mkOption {
      description = "WAV file to play when only one person is in the conference";
      type = nullOr path;
      default = null;
    };

    extraConfigure = mkOption {
      description = "postPatch for the FreeSWITCH configuration. Has xmlstarlet in $PATH";
      type = lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    services.freeswitch = {
      enable = true;
      enableReload = true; # Forces FreeSWITCH to use /etc/freeswitch

      package = pkgs.freeswitch.overrideAttrs (oA: rec {
        # Add modules without overwriting the default modules
        # TODO Upstream
        preConfigure = ''
          ${oA.preConfigure}
          {
            echo
            echo 'applications/mod_av'
            echo 'formats/mod_opusfile'
            echo 'applications/mod_av'
          } >> modules.conf
        '';
        buildInputs = oA.buildInputs ++ (with pkgs; [ libopus ffmpeg opusfile libogg libopusenc ]);

        # TOREM 20.09
        postPatch = ''
          ${oA.postPatch}

          # Disable an advertisement for a conference nobody cares about
          for f in src/include/cc.h libs/esl/src/include/cc.h; do
            {
              echo 'const char *cc = "";'
              echo 'const char *cc_s = "";'
            } > $f
          done
        '';
      });
    };

    # Overwrite NixOS configuration
    environment.etc.freeswitch.source = mkForce (pkgs.bbbPackages.freeswitchConfig.override {
      extraConfigure = ''
        # Ports
        xml ed -P -L -u '/configuration/settings/param[@name="listen-port"]/@value' -v '${toString cfg.eventsPort}' autoload_configs/event_socket.conf.xml
        xml ed -P -L -u '/profile/settings/param[@name="wss-binding"]/@value' -v ':${toString cfg.wssPort}' sip_profiles/external.xml
        xml ed -P -L \
          -u '/configuration/settings/param[@name="rtp-start-port"]/@value' -v '${toString cfg.rtpMinPort}' \
          -u '/configuration/settings/param[@name="rtp-end-port"]/@value' -v '${toString cfg.rtpMaxPort}' \
          autoload_configs/switch.conf.xml

        # Loglevel
        for f in syslog switch console; do
          xml ed -P -L -u '/configuration/settings/param[@name="loglevel"]/@value' -v '${cfg.loglevel}' autoload_configs/$f.conf.xml
        done

        # Public IP
        ${if cfg.publicIP == null then ''
          xml ed -P -L -d '/include/X-PRE-PROCESS[starts-with(@data, "local_ip_v4=")]' vars.xml
        '' else ''
          xml ed -P -L -u '/include/X-PRE-PROCESS[starts-with(@data, "local_ip_v4=")]/@data' -v 'local_ip_v4=${cfg.publicIP}' vars.xml
        ''}

        # Muted/Unmuted sounds
        ${optionalString (!cfg.mutedUnmutedSounds) ''
          xml ed -P -L -d '/configuration/profiles/profile/*[@name="muted-sound"]' autoload_configs/conference.conf.xml
          xml ed -P -L -d '/configuration/profiles/profile/*[@name="unmuted-sound"]' autoload_configs/conference.conf.xml
        ''}

        # Music on hold
        ${optionalString (cfg.aloneMusic != null) ''
          xml ed -P -L \
            -i '/configuration/profiles/profile[@name="cdquality"]/param[1]' -t elem -n param -v "" \
            -i '/configuration/profiles/profile[@name="cdquality"]/param[1]' -t attr -n name -v moh-sound \
            -i '/configuration/profiles/profile[@name="cdquality"]/param[1]' -t attr -n value -v '${cfg.aloneMusic}' \
            autoload_configs/conference.conf.xml
        ''}

        ${cfg.extraConfigure}
      '';
    });

    systemd.services.freeswitch-config-reload.enable = false;
    systemd.services.freeswitch = {
      reloadIfChanged = true;
      restartTriggers = [ config.environment.etc.freeswitch.source ];
      sandbox = 2;
      serviceConfig = {
        # TOREM 20.09
        Restart = mkForce "on-failure";
        CPUSchedulingPolicy = "fifo";

        # Required for the recording scripts
        DynamicUser = mkForce false;
        User = "freeswitch";
        UMask = "0027";

        CapabilityBoundingSet = "CAP_SYS_NICE";
        AmbientCapabilities = "CAP_SYS_NICE";

        PrivateNetwork = false;
        SystemCallFilter = "@resources @system-service";
      };
      apparmor = {
        packages = [ config.environment.etc.freeswitch.source ];
        extraConfig = ''
          /dev/shm/core.db rwklm,
          /dev/shm/core.db-journal rwklm,
          @{PROC}@{pid}/net/route r,

          capability sys_nice,

          network netlink raw,
          network unix stream,
          network inet dgram,
          network inet stream,
          network inet6 dgram,
          network inet6 stream,
        '';
      };
    };

    # Group is temporary until recording is done
    systemd.tmpfiles.rules = [
      ''d /var/lib/freeswitch/meetings 2750 freeswitch nogroup 5d''
    ];

    users.users.freeswitch = {
      isSystemUser = true;
      description = "FreeSWITCH service user";
    };

    # TOREM 20.09
    environment.systemPackages = with pkgs; [ config.services.freeswitch.package ]; # For fs_cli
  };
}
