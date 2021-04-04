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

      package = pkgs.freeswitchPackages.freeswitch;
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

    systemd.services.freeswitch = {
      wantedBy = mkForce [ "bigbluebutton.target" ];
      partOf = [ "bigbluebutton.target" ];
      stopIfChanged = false;

      postStart = ''
        while ! ${pkgs.iproute}/bin/ss -tln | ${pkgs.gnugrep}/bin/grep -q :${toString cfg.wssPort}; do
          sleep .2
        done
      '';

      sandbox = 2;
      serviceConfig = {
        # Required for the recording scripts
        DynamicUser = mkForce false;
        User = "freeswitch";
        UMask = "0027";

        AmbientCapabilities = "CAP_SYS_NICE";

        PrivateNetwork = false;
        SystemCallFilter = "@resources @system-service";
      };

      apparmor = {
        enable = true;
        packages = [ config.environment.etc.freeswitch.source ];
        extraConfig = ''
          /dev/shm/core.db rwklm,
          /dev/shm/core.db-journal rwklm,
          @{PROC}@{pid}/net/route r,
          @{PROC}@{pid}/net/tcp r,
          @{PROC}@{pid}/net/tcp6 r,

          capability sys_nice,

          network udp,
          network tcp,
          network netlink raw,
        '';
      };
    };

    systemd.services.freeswitch-config-reload = {
      stopIfChanged = false;
      sandbox = 2;
      wantedBy = mkForce [ "bigbluebutton.target" ];
      partOf = [ "bigbluebutton.target" ];
      serviceConfig = {
        # Upstream does this in an impure fashion
        ExecStart = lib.mkForce "${pkgs.systemd}/bin/systemctl reload-or-restart --no-block freeswitch.service";
        User = "freeswitch";
        Group = "nogroup";
        SystemCallFilter = "@system-service";
      };
      apparmor = {
        enable = true;
        extraConfig = ''
          /run/dbus/system_bus_socket rw,
        '';
      };
    };

    # Group is temporary until recording is done
    systemd.tmpfiles.rules = [
      ''d /var/lib/freeswitch/meetings 2750 freeswitch nogroup 5d''
    ];

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "freeswitch.service" &&
          action.lookup("verb") == "reload-or-restart" &&
          subject.user == "freeswitch") {
            return polkit.Result.YES;
        }
      });
    '';

    users.users.freeswitch = {
      isSystemUser = true;
      description = "FreeSWITCH service user";
    };
  };
}
