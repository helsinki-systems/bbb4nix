{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.webrtc-sfu;
in {
  options.services.bigbluebutton.webrtc-sfu = with types; {
    enable = mkEnableOption "the WebRTC SFU component";

    config = mkOption {
      description = "Configuration to pass to WebRTC SFU";
      default = {};
      type = let
        valueType = nullOr (oneOf [
          bool
          int
          float
          str
          (lazyAttrsOf valueType)
          (listOf valueType)
        ]) // {
          description = "Yaml value";
          emptyValue.value = {};
        };
      in valueType;
    };

    myIP = mkOption {
      description = "IP of this host. Not used for Kurento when overwriting Kurento config with the config option.";
      type = str;
      default = "";
    };

    port = mkOption {
      description = "Port to listen on";
      type = port;
      default = 3008;
    };
  };

  config = mkIf cfg.enable {
    services.bigbluebutton.webrtc-sfu.config = {
      recordingBasePath = "file:///var/lib/kurento";
      clientPort = mkDefault cfg.port;
      freeswitch.esl_port = mkDefault config.services.bigbluebutton.freeswitch.eventsPort;
      localIpAddress = mkDefault cfg.myIP;
      kurento = mkDefault [
        {
          ip = "";
          url = "ws://127.0.0.1:${toString config.services.bigbluebutton.kurento-media-server.port}/kurento";
          ipClassMappings = {
            local = {};
            private = {};
            public = {};
          };
          options = {
            failAfter = 5;
            request_timeout = 30000;
            response_timeout = 30000;
          };
        }
      ];
    };

    systemd.services.bbb-webrtc-sfu = {
      description = "BigBlueButton WebRTC SFU";
      wantedBy = [ "bigbluebutton.target" ];
      partOf = [ "bigbluebutton.target" ];
      wants = [ "freeswitch.service" "kurento-media-server.service" ];
      requires = [ "kurento-media-server.service" ];
      stopIfChanged = false;

      environment = {
        NODE_ENV = "production";
        NODE_CONFIG_DIR = "/run/bbb-webrtc-sfu";
      };

      preStart = ''
        # YML -> JSON
        ${pkgs.yq}/bin/yq . '${pkgs.bbbPackages.webrtcSfu}/lib/node_modules/bbb-webrtc-sfu/config/default.example.yml' > /run/bbb-webrtc-sfu/basic.json

        # Secrets file must be valid
        cat /var/lib/secrets/bbb-webrtc-sfu.json > /run/bbb-webrtc-sfu/secret.json
        if [ "$(wc -l /run/bbb-webrtc-sfu/secret.json | cut -d' ' -f1)" -lt 1 ]; then
          echo '{}' > /run/bbb-webrtc-sfu/secret.json
        fi

        # Merge configs
        ${pkgs.jq}/bin/jq \
          --null-input \
          --argfile a '/run/bbb-webrtc-sfu/basic.json' \
          --argfile b '${pkgs.writeText "bbb-webrtc-sfu.json" (builtins.toJSON cfg.config)}' \
          --argfile c /run/bbb-webrtc-sfu/secret.json \
          '$a * $b * $c' \
          > /run/bbb-webrtc-sfu/production.json
      '';

      sandbox = 2;
      serviceConfig = {
        ExecStart = "${pkgs.bbbPackages.webrtcSfu}/bin/bbb-webrtc-sfu";
        Restart = "on-failure";

        RuntimeDirectory = "bbb-webrtc-sfu";

        User = "bbb-webrtc-sfu";
        Group = "bbb-webrtc-sfu";

        PrivateNetwork = false;
        MemoryDenyWriteExecute = false;
        SystemCallFilter = "@system-service";
      };

      apparmor = {
        enable = true;
        extraConfig = ''
          /var/lib/secrets/bbb-webrtc-sfu.json r,
          @{PROC}@{pid}/fd/ r,
          @{sys}fs/cgroup/memory/memory.limit_in_bytes r,

          network udp,
          network tcp,
          deny network netlink raw,
        '';
      };
    };

    systemd.tmpfiles.rules = [
      "f /var/lib/secrets/bbb-webrtc-sfu.json 0400 bbb-webrtc-sfu nogroup -"
    ];

    users.users.bbb-webrtc-sfu = {
      description = "BigBlueButton WebRTC SFU user";
      isSystemUser = true;
      group = "bbb-webrtc-sfu";
    };
    users.groups.bbb-webrtc-sfu = {};
  };
}
