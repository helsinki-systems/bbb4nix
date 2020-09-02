{ config, lib, pkgs, ... }: with lib; let
  cfg = config.helsinki.cooler-redis;
  mkConfig = name: config: pkgs.writeText "redis-${name}.conf" ''
    daemonize yes
    supervised systemd
    syslog-enabled yes
    dbfilename dump.rdb
    pidfile /run/redis/${name}.pid
    unixsocket /run/redis/${name}.sock
    dir /var/lib/redis/${name}
    ${config.extraConfig}
  '';
in {
  options.helsinki.cooler-redis = with types; {
    vmOverCommit = mkOption {
      description = "Set vm.overcommit_memory to 1 (Suggested for Background Saving: http://redis.io/topics/faq)";
      type = bool;
      default = false;
    };

    disableHugepages = mkOption {
      description = "Disable transparent hugepages support";
      type = bool;
      default = false;
    };

    instances = mkOption {
      description = "Redis instances to deploy";
      default = {};
      type = attrsOf (submodule ({ ... }: {
        options = {
          extraConfig = mkOption {
            description = "redis.conf verbatim config";
            type = lines;
            default = "";
          };
        };
      }));
    };
  };

  config = mkIf (cfg.instances != {}) {
    boot.kernel.sysctl = mkIf cfg.vmOverCommit {
      "vm.overcommit_memory" = "1";
    };
    boot.kernelParams = mkIf cfg.disableHugepages [ "transparent_hugepage=never" ];
    environment.systemPackages = [ pkgs.redis ];

    systemd.services = mapAttrs' (name: config: nameValuePair "redis-${name}" {
      description = "Redis instance ${name}";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      sandbox = 1;

      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.redis}/bin/redis-server ${mkConfig name config}";
        Restart = "always";
        # Increase limit
        LimitNOFILE = 10032;

        StateDirectory = "redis/${name}";
        RuntimeDirectory = "redis";
        RuntimeDirectoryPreserve = true;

        User = "redis";
        Group = "redis";

        SystemCallFilter = "@basic-io @file-system @io-event @network-io @sync @system-service @timer";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
      };

      apparmor = {
        enable2 = true;
        extraConfig = ''
          @{PROC}@{pid}/stat r,
          @{PROC}@{pid}/smaps r,
          /sys/kernel/mm/transparent_hugepage/enabled r,
          /proc/sys/net/core/somaxconn r,

          network unix dgram,
          network unix stream,
          network inet tcp,
          network inet6 tcp,
        '';
      };
    }) cfg.instances;

    users.groups.redis = {};
    users.users.redis = {
      description = "Redis service user";
      isSystemUser = true;
      group = "redis";
    };
  };
}
