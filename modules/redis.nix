{ config, lib, ... }: with lib;
let
  cfg = config.services.bigbluebutton.redis;
in {
  options.services.bigbluebutton.redis = {
    enable = mkEnableOption "redis instance for BBB";
  };

  config = mkIf cfg.enable {
    helsinki.cooler-redis = {
      # TODO: lots of these things are _probably_ defaults and can be dropped
      instances.bigbluebutton.extraConfig = ''
        bind 127.0.0.1
        port 6379
        timeout 0
        tcp-backlog 511
        tcp-keepalive 0
        databases 16
        save 900 1
        save 300 10
        save 60 10000
        stop-writes-on-bgsave-error yes
        rdbcompression yes
        rdbchecksum yes
        dbfilename dump.rdb
        slave-serve-stale-data yes
        slave-read-only yes
        repl-diskless-sync no
        repl-diskless-sync-delay 5
        repl-disable-tcp-nodelay no
        slave-priority 100
        appendonly no
        appendfilename "appendonly.aof"
        appendfsync everysec
        no-appendfsync-on-rewrite no
        auto-aof-rewrite-percentage 100
        auto-aof-rewrite-min-size 64mb
        aof-load-truncated yes
        lua-time-limit 5000
        slowlog-log-slower-than 10000
        slowlog-max-len 128
        latency-monitor-threshold 0
        notify-keyspace-events ""
        hash-max-ziplist-entries 512
        hash-max-ziplist-value 64
        list-max-ziplist-entries 512
        list-max-ziplist-value 64
        set-max-intset-entries 512
        zset-max-ziplist-entries 128
        zset-max-ziplist-value 64
        hll-sparse-max-bytes 3000
        activerehashing yes
        client-output-buffer-limit normal 0 0 0
        client-output-buffer-limit slave 256mb 64mb 60
        client-output-buffer-limit pubsub 32mb 8mb 60
        hz 10
        aof-rewrite-incremental-fsync yes
      '';
      disableHugepages = true;
      vmOverCommit = true;
    };

    boot.kernel.sysctl = {
      "net.core.somaxconn" = "512";
    };

    systemd.services.redis-bigbluebutton.serviceConfig = {
      PrivateNetwork = false;
    };
  };
}
