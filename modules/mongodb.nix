{ config, lib, ... }: with lib;
let
  cfg = config.services.bigbluebutton.mongodb;
in {
  options.services.bigbluebutton.mongodb = {
    enable = mkEnableOption "MongoDB and configure it for BBB";
  };

  config = mkIf cfg.enable {
    services.mongodb = {
      enable = true;
      enableAuth = false;
      # replSetName = "rs0"; # This is needed for replication, but apparently breaks bbb-html5 ???
      bind_ip = "127.0.1.1";
      dbpath = "/tmp/db";
      pidFile = "/run/mongodb/pid";
      extraConfig = ''
        net.port: 27017
        storage.journal.enabled: false
        storage.wiredTiger:
          engineConfig:
            cacheSizeGB: 0
            journalCompressor: none
            directoryForIndexes: true
          collectionConfig:
            blockCompressor: none
          indexConfig:
            prefixCompression: false
        replication.oplogSizeMB: 8
      '';
    };

    systemd.services.mongodb = {
      sandbox = 1;
      apparmor.extraConfig = ''
        deny @{PROC}sys/kernel/osrelease r,
        deny @{PROC}version r,
        deny @{PROC}@{pid}/net/snmp r,
        deny @{PROC}@{pid}/net/netstat r,
        deny @{sys}block/ r,

        ${config.environment.etc."os-release".source} r,
        @{PROC}diskstats r,
        @{PROC}@{pid}/stat r,
        @{sys}kernel/mm/transparent_hugepage/** r,

        network unix dgram,
        network unix stream,
        network inet stream,
      '';
      serviceConfig = {
        PrivateNetwork = false;
        RuntimeDirectory = "mongodb";
      };
    };
  };
}
