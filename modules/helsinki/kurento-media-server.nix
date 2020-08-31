{ config, pkgs, lib, ... }: with lib;
let
  cfg = config.services.kurento-media-server;
  bbbLib = import ../lib.nix { inherit pkgs lib; };

  logConfig = "${toString cfg.defaultLogLevel}"
    + optionalString (cfg.logLevels != {}) ("," + (concatStringsSep "," (mapAttrsToList (k: v: "${k}:${toString v}") cfg.logLevels)));

  configDir = pkgs.symlinkJoin {
    name = "kurento-etc";
    paths = [
      (pkgs.writeTextDir "kurento.conf.json" (builtins.toJSON {
          mediaServer = cfg.mediaServerConfig;
      }))
    ] ++ mapAttrsToList (n: v: pkgs.writeTextDir
      "modules/kurento/${n}.conf.json"
      (builtins.toJSON v)
    ) cfg.jsonModuleConfigs
    ++ mapAttrsToList (n: v: pkgs.writeTextDir
      "modules/kurento/${n}.conf.ini"
      (concatStringsSep "\n" (mapAttrsToList (n: v: "${n}=${toString v}") v))
    ) cfg.iniModuleConfigs;
  };

  gstPluginDir = pkgs.symlinkJoin {
    name = "kurento-gst-plugins";
    paths = cfg.modules ++ (with pkgs.kurentoPackages.gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad pkgs.libnice.out ]);
  };

in {
  options.services.kurento-media-server = with types; {
    enable = mkEnableOption "Kurento Media Server";

    extraArgs = mkOption {
      description = "List of command line parameters for the daemon";
      type = listOf str;
      default = [ ];
      example = [ "-n" "1" ];
    };

    defaultLogLevel = mkOption {
      description = "Default log level for all factories";
      type = ints.between 1 8;
      default = 3;
    };

    logLevels = mkOption {
      description = "Log levels for the different factories";
      type = attrsOf (ints.between 1 8);
      default = {
        "Kurento*" = 4;
        "KurentoLoadConfig" = 3; # No need to dump the config to stdout
        "kms*" = 4;
        "sdp*" = 4;
        "webrtc*" = 4;
        "*rtpendpoint" = 4;
        "rtp*handler" = 4;
        "rtpsynchronizer" = 4;
        "agnosticbin" = 4;
      };
    };

    modules = mkOption {
      description = "Kurento modules to load";
      type = listOf path;
      default = with pkgs.kurentoPackages; [ kms-core kms-elements kms-filters ];
      defaultText = "[ \${pkgs.kurentoPackages.kms-core} \${pkgs.kurentoPackages.kms-elements} \${pkgs.kurentoPackages.kms-filters} ]";
    };

    mediaServerConfig = mkOption {
      description = "kurento.conf.json mediaServer object contents";
      default = { };
      type = bbbLib.jsonType;
      example = {
        resources = {
          garbageCollectorPeriod = 240;
          disableRequestCache = false;
        };
      };
    };

    iniModuleConfigs = mkOption {
      description = "Kurento module configurations in INI format";
      default = { };
      type = attrsOf (attrsOf (oneOf [ bool int float str ]));
    };

    jsonModuleConfigs = mkOption {
      description = "Kurento module configurations in JSON format";
      default = { };
      type = attrsOf bbbLib.jsonType;
      example = {
        SdpEndpoint = {
          numAudioMedias = 1;
          numVideoMedias = 1;
          audioCodecs = [
            { name = "opus/48000/2"; }
            { name = "PCMU/8000"; }
            { name = "AMR/8000"; }
          ];
          videoCodecs = [
            { name = "VP8/90000"; }
            { name = "H264/90000"; }
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.kurento-media-server = {
      description = "Kurento Media Server";
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configDir ];

      environment = {
        GST_REGISTRY = "/run/kurento";
        KURENTO_MODULES_PATH = lib.makeLibraryPath cfg.modules;
        LD_LIBRARY_PATH = "${pkgs.kurentoPackages.gst_all_1.gst-plugins-bad}/lib";
        GST_DEBUG_NO_COLOR = "1";
        GST_DEBUG = logConfig;
        GST_PLUGIN_SYSTEM_PATH = gstPluginDir + "/lib/gstreamer-1.0";
      };

      sandbox = 2;
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kurentoPackages.kurento-media-server}/bin/kurento-media-server ${escapeShellArgs cfg.extraArgs}";
        Restart = "on-failure";

        User = "kurento";
        PrivateNetwork = false;
        PrivateUsers = false;
        RuntimeDirectory = "kurento";
        SystemCallFilter = "@system-service";

        LimitNOFILE = "8192";
      };

      apparmor = {
        packages = [ configDir gstPluginDir ];
        extraConfig = ''
          @{PROC}@{pid}/fd/ r,
          deny /dev/ r,
          deny @{PROC}@{pid}/stat r,

          network netlink raw,
          network unix dgram,
          network unix stream,
          network inet dgram,
          network inet stream,
          network inet6 dgram,
          network inet6 stream,
        '';
      };
    };

    users.users.kurento = {
      isSystemUser = true;
      description = "Kurento media server service user";
    };

    services.kurento-media-server.iniModuleConfigs.UriEndpoint.defaultPath = mkDefault "file:///var/lib/kurento/";

    environment.etc.kurento.source = configDir;
  };
}
