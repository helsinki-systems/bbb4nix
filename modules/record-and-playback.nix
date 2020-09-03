{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.record-and-playback;
  bbbLib = import ./lib.nix { inherit pkgs lib; };
in {
  options.services.bigbluebutton.record-and-playback = {
    enable = mkEnableOption "the BBB record and playback scripts";

    config = mkOption {
      description = "Options, get merged with defaults";
      default = {};
      type = bbbLib.jsonType;
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      packages = [ pkgs.bbbPackages.recordAndPlaybackScripts ];

      services = let
        mkRaPService = name: {
          name = "bbb-rap-${name}";
          value = {
            sandbox = 2;
            wantedBy = [ "bbb-record-core.target" ];

            after = [ "bbb-rap-prepare-config.service" ];
            path = with pkgs; [
              (python3.withPackages (p: with p; [ lxml PyICU ]))
              ffmpeg
              gnuplot
              imagemagick_light
              poppler_utils   # pdftocairo
              rsync
              bbbPackages.recordAndPlaybackScriptsRuby
              "${bbbPackages.recordAndPlaybackScripts}/core/scripts/utils"
            ];

            serviceConfig = {
              MemoryDenyWriteExecute = false;
              Group = "bbb-record";
              User = "bbb-rap";

              PrivateNetwork = false;

              ReadWritePaths = [ "/var/lib/bigbluebutton/recording/" "/var/lib/bigbluebutton/captions/"  "/var/lib/kurento/" "/var/lib/freeswitch/meetings/" "/var/log/bigbluebutton/" ];
              ReadOnlyPaths = [ "/run/bbb-rap/" "/var/lib/bigbluebutton/" ];
            };

            apparmor.extraConfig = ''
              network unix dgram,
              network unix stream,
              network inet stream,
              network inet dgram,
              network inet6 stream,
              network inet6 dgram,
            '';
          };
        };
      in {
        # archive-worker
        # - legt /var/lib/bigbluebutton/recording/status/archived an und muss schreiben können
        # - muss in /var/lib/bigbluebutton/recording/status/recorded/ schreiben können
        # - recording-raw
        # - redis
        # - events.xml
        # - muss aus freeswitch lesen können und schreiben um die meeting id zu löschen
        # - /var/lib/freeswitch/meetings
        # - redet mit dem etherpad
        # - presentation id aus /var/lib/bigbluebutton
        # - /var/lib/kurento    # recordings und screenshare   # muss auch schreiben können
        # sanity-worker
        # - gleich wie archive (nur ohne kurento, freeswitch, etc), aber legt ziel nach sanity und liest aus status archived
        # process-worker
        # - schaut in sanity, schreibt in process
        # - führt captions.rb
        # - führt process/*.rb aus
        # publish-worker
        # - führt publish/*.rb aus

        bbb-rap-prepare-config = let
          configJson = pkgs.writeText "bbb-rap-settings.json" (builtins.toJSON cfg.config);
        in {
          script = ''
            ${pkgs.yq}/bin/yq . ${pkgs.bbbPackages.recordAndPlaybackScripts}/core/scripts/bigbluebutton.yml.default > /run/bbb-rap/defaults.json
            ${pkgs.jq}/bin/jq -s '.[0] * .[1]' /run/bbb-rap/defaults.json ${configJson} > /run/bbb-rap/conf.json
          '';

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;

            ReadWritePaths = [ "/run/bbb-rap" ];
          };

          wantedBy = [ "bbb-record-core.target" ];
          restartIfChanged = true;
        };
      } // (listToAttrs (map mkRaPService [ "archive-worker" "caption-inbox" "events-worker" "process-worker" "publish-worker" "sanity-worker" ]));

      timers."bbb-record-core" = {
        wantedBy = [ "bigbluebutton.target" ];
      };

      slices."bbb_record_core.slice" = {
        description = "BigBlueButton Recording Processing";
      };

      tmpfiles.rules = [
        "d /run/bbb-rap 0700 bbb-rap bbb-record -"  # not a RuntimeDirectory, because a bunch of different systemd services need to read this
        "d /var/lib/bigbluebutton/captions 0770 bbb-web bbb-record -"  # not owned by bbb-rap, because "unsafe path transition"
        "d /var/lib/bigbluebutton/captions/inbox 0770 bbb-web bbb-record -"
        "d /var/log/bigbluebutton 0770 bbb-rap bbb-record -"
        "d /var/lib/kurento 0770 kurento bbb-record -"
      ];
    };

    users.users.bbb-rap = {
      description = "BigBlueButton Recording and Playback";
      isSystemUser = true;
    };

    users.groups.bbb-record = {};

  };
}
