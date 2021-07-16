{ lib, helsinkiLib, pkgs, config, ... }: let
  cfg = config.services.bigbluebutton.soffice-conversion-server;
in {
  options.services.bigbluebutton.soffice-conversion-server = {
    enable = lib.mkEnableOption "soffice conversion server";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.bbb-soffice-conversion-server = {
      sandbox = 2;
      apparmor = {
        enable = true;
        packages = config.fonts.fontconfig.confPackages;
        extraConfig = ''
          @{PROC}/sys/net/core/somaxconn r,
          @{PROC}@{pid}/fd/ r,
        '';
      };

      stopIfChanged = false;

      environment.HOME = "/run/bbb-soffice-conversion-server";

      serviceConfig = {
        User = "bbb-soffice";
        Group = "bbb-soffice";

        PrivateUsers = false;

        ExecStart = "${pkgs.bbb-soffice-conversion-server}/bin/bbb-soffice-conversion-server -s /run/bbb-soffice-conversion-server/sock -lo ${pkgs.bbb-soffice-conversion-server.passthru.libreoffice}/lib/libreoffice/program/";

        Restart = "on-failure";
        RestartSec = "2s";
        RuntimeDirectory = "bbb-soffice-conversion-server";
        RuntimeDirectoryMode = "750";
        UMask = "0007";

        SystemCallFilter = "@system-service";
      };

      wantedBy = [ "bigbluebutton.target" ];
    };

    users.users.bbb-soffice.isSystemUser = true;
    users.groups.bbb-soffice = {};
  };
}
