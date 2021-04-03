{ config, lib, pkgs, ... }: with lib; let
  cfg = config.helsinki.cooler-redis;

  mkValueString = value:
    if value == true then "yes"
    else if value == false then "no"
    else generators.mkValueStringDefault {} value;

  mkConfig = name: settings: pkgs.writeText "redis-${name}.conf" (generators.toKeyValue {
    listsAsDuplicateKeys = true;
    mkKeyValue = generators.mkKeyValueDefault { inherit mkValueString; } " ";
  } ({
    daemonize = false;
    supervised = "systemd";
    syslog-enabled = true;
    dbfilename = "dump.rdb";
    pidfile = "/run/redis/${name}.pid";
    unixsocket = "/run/redis/${name}.sock";
    dir = "/var/lib/redis/${name}";
  } // settings));

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
            description = "redis.conf configuration";
            type = attrsOf (oneOf [ bool int str (listOf str) ]);
            default = {};
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
      stopIfChanged = false;
      sandbox = 2;

      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.redis}/bin/redis-server ${mkConfig name config.extraConfig}";
        Restart = "always";
        # Increase limit
        LimitNOFILE = 10032;

        StateDirectory = "redis/${name}";
        RuntimeDirectory = "redis";
        RuntimeDirectoryPreserve = true;

        User = "redis";
        Group = "redis";

        SystemCallFilter = "@system-service";
      };

      apparmor = {
        enable = true;
        extraConfig = ''
          @{PROC}@{pid}/stat r,
          @{PROC}@{pid}/smaps r,
          @{PROC}@{pid}/oom_score_adj r,
          @{PROC}/sys/net/core/somaxconn r,
          /sys/kernel/mm/transparent_hugepage/enabled r,

          network tcp,
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
