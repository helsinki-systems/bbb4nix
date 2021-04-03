{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.bigbluebutton.soffice;
in {
  options.services.bigbluebutton.soffice = with types; {
    enable = mkEnableOption "the BigBlueButton soffice component for web";

    workers = mkOption {
      description = "Number of worker services to spawn";
      type = ints.unsigned;
      default = 4;
    };

    portBase = mkOption {
      description = "Lowest port for a worker";
      type = port;
      default = 8201;
    };
  };
  config = mkIf cfg.enable {

    systemd.services = listToAttrs (map (n: nameValuePair "bbb-soffice-${toString n}" {
      description = "BigBlueButton soffice service ${toString n}";
      wantedBy = [ "bigbluebutton.target" ];
      partOf = [ "bigbluebutton.target" ];
      stopIfChanged = false;

      environment = {
        HOME = "/tmp";
        DBUS_SESSION_BUS_ADDRESS = "/tmp/dbus"; # Required but not used
      };

      sandbox = 2;
      serviceConfig = {
        ExecStart = "${pkgs.libreoffice}/bin/soffice "
          + "--accept=socket,host=127.0.0.1,port=${toString (cfg.portBase + n - 1)},tcpNoDelay=1;urp;StarOffice.ServiceManager "
          + "--headless "
          + "--invisible "
          + "--nocrashreport "
          + "--nodefault "
          + "--nofirststartwizard "
          + "--nolockcheck "
          + "--nologo "
          + "--norestore "
          + "-env:UserInstallation=file:///tmp/";
        Restart = "on-failure";
        UMask = "0007";

        StateDirectory = "bigbluebutton-soffice/${fixedWidthString 2 "0" (toString n)}";
        StateDirectoryMode = "2770";

        User = "bbb-soffice";
        Group = "bbb-soffice";

        PrivateNetwork = false;
        SystemCallFilter = "@system-service";
      };

      apparmor = {
        enable = true;
        packages = with pkgs; [ coreutils config.environment.etc.fonts.source ];
        extraConfig = ''
          deny / r,
          deny /proc/loadavg r,
          deny @{PROC}@{pid}/mountinfo r,
          deny /sys/** r,
          deny ${config.environment.etc."os-release".source} r,

          network tcp,
          deny network udp,
          deny network netlink raw,
        '';
      };
    }) (range 1 cfg.workers));

    systemd.tmpfiles.rules = map (n: "d /var/lib/bigbluebutton-soffice/${fixedWidthString 2 "0" (toString n)} 2770 bbb-soffice bbb-soffice 1d") (range 1 cfg.workers);

    users.users.bbb-soffice = {
      description = "BigBlueButton soffice user";
      isSystemUser = true;
    };
    users.groups.bbb-soffice = {};
  };
}
