{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.services.bigbluebutton.nginx;
in {
  options.services.bigbluebutton.nginx = with types; {
    enable = mkEnableOption "the nginx webserver config for BigBlueButton";

    domain = mkOption {
      description = "Domain name of the virtualhost";
      default = config.services.bigbluebutton.simple.domain;
      type = str;
    };

    virtualHost = mkOption {
      description = "Name of the virtualhost. You probably don't want to change this.";
      type = str;
      default = "bigbluebutton";
    };
  };

  config = mkIf cfg.enable {
    #systemd.tmpfiles.rules = [
    #  "d /var/lib/secrets/bbb 0755 root root -"
    #];

    helsinki.nginx.enable = true;
    helsinki.nginx.extraCiphers = [ "AES256-GCM-SHA384" ]; # fore node.js 8.x
    services.nginx.recommendedProxySettings = true;
    services.nginx.virtualHosts."${cfg.virtualHost}" = {
      serverName = cfg.domain;

      locations."~ (/open/|/close/|/idle/|/send/|/fcs/)" = {
        proxyPass = "http://127.0.0.1:5080";
        extraConfig = ''
          proxy_buffering off;
          keepalive_requests 1000000000;
        '';
      };

      locations."/deskshare" = {
        proxyPass = "http://127.0.0.1:5080";
        extraConfig = ''
          proxy_redirect default;

          proxy_buffer_size 4k;
          proxy_buffers 4 32k;
          proxy_busy_buffers_size 64k;
          proxy_temp_file_write_size 64k;
          include ${config.services.nginx.package}/conf/fastcgi.conf;
        '';
      };

      locations."/" = {
        root = "${pkgs.bbbPackages.source}/bigbluebutton-config/web";
        index = "index.html index.htm";
        extraConfig = "expires 1m;";
      };

      # bbb-html5.nginx
      locations."/html5client" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
      locations."/_timesync" = {
        proxyPass = "http://127.0.0.1:3000";
      };

      # client.nginx
      locations."~ ^/client/conf/config.xml$".extraConfig = let
        clientConfig = pkgs.runCommand "bbb-client-config.xml" {} ''
          sed -e 's/BBB_DOMAIN/${cfg.domain}/g' < ${./client-config.xml} > $out
        '';
      in ''
        alias ${clientConfig};
      '';
      locations."/client/" = {
        index = "index.html index.htm";
        extraConfig = ''
          alias ${pkgs.bbbPackages.source}/bigbluebutton-client/resources/prod/;
          expires 1m;
        '';
      };

      # notes.nginx
      locations."~ \"^\\/pad\\/p\\/(\\w+)$\"" = {
        proxyPass = "http://127.0.0.1:9001";
        extraConfig = ''
          rewrite /pad/(.*) /$1 break;
          rewrite ^/pad$ /pad/ permanent;
          proxy_pass_header Server;
          proxy_redirect / /pad;
          proxy_buffering off;

          auth_request /bigbluebutton/connection/checkAuthorization;
          auth_request_set $auth_status $upstream_status;
        '';
      };
      locations."/pad" = {
        proxyPass = "http://127.0.0.1:9001/";
        extraConfig = ''
          rewrite /pad/(.*) /$1 break;
          rewrite ^/pad$ /pad/ permanent;
          proxy_pass_header Server;
          proxy_redirect / /pad;
          proxy_buffering off;
        '';
      };
      locations."/pad/socket.io" = {
        proxyPass = "http://127.0.0.1:9001/";
        proxyWebsockets = true;
        extraConfig = ''
          rewrite /pad/socket.io/(.*) /socket.io/$1 break;
          proxy_redirect / /pad/;
          proxy_buffering off;
        '';
      };
      locations."/static" = {
        proxyPass = "http://127.0.0.1:9001/";
        extraConfig = ''
          rewrite /static/(.*) /static/$1 break;
          proxy_buffering off;
        '';
      };

      # presentation-slides.nginx
      locations."~^\\/bigbluebutton\\/presentation\\/(?<meeting_id_1>[A-Za-z0-9\\-]+)\\/(?<meeting_id_2>[A-Za-z0-9\\-]+)\\/(?<pres_id>[A-Za-z0-9\\-]+)\\/svg\\/(?<page_num>\\d+)$".extraConfig = ''
        default_type image/svg+xml;
        alias /var/lib/bigbluebutton/$meeting_id_2/$meeting_id_2/$pres_id/svgs/slide$page_num.svg;
      '';
      locations."~^\\/bigbluebutton\\/presentation\\/(?<meeting_id_1>[A-Za-z0-9\\-]+)\\/(?<meeting_id_2>[A-Za-z0-9\\-]+)\\/(?<pres_id>[A-Za-z0-9\\-]+)\\/thumbnail\\/(?<page_num>\\d+)$".extraConfig = ''
        default_type image/png;
        alias /var/lib/bigbluebutton/$meeting_id_2/$meeting_id_2/$pres_id/thumbnails/thumb-$page_num.png;
      '';
      locations."~^\\/bigbluebutton\\/presentation\\/(?<meeting_id_1>[A-Za-z0-9\\-]+)\\/(?<meeting_id_2>[A-Za-z0-9\\-]+)\\/(?<pres_id>[A-Za-z0-9\\-]+)\\/textfiles\\/(?<page_num>\\d+)$".extraConfig = ''
        default_type text/plain;
        alias /var/lib/bigbluebutton/$meeting_id_2/$meeting_id_2/$pres_id/textfiles/slide-$page_num.txt;
      '';
      # presentation.nginx
      locations."/playback/presentation/playback.html".extraConfig = ''
        return 301 /playback/presentation/0.81/playback.html?$query_string;
      '';
      locations."/playback/presentation" = {
        root = "${pkgs.bbbPackages.source}/record-and-playback/presentation";
        index = "index.html index.htm";
      };
      locations."/presentation" = {
        root = "/var/lib/bigbluebutton/published";
        index = "index.html index.htm";
      };
      # screenshare.nginx
      locations."/screenshare" = {
        proxyPass = "http://127.0.0.1:5080";
        extraConfig = ''
          proxy_redirect default;
          proxy_buffer_size 4k;
          proxy_buffers 4 32k;
          proxy_busy_buffers_size 64k;
          proxy_temp_file_write_size 64k;
          include ${config.services.nginx.package}/conf/fastcgi.conf;
        '';
      };
      # sip.nginx
      locations."/ws" = {
        proxyPass = "https://${cfg.domain}:7443";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 6h;
          proxy_send_timeout 6h;
          client_body_timeout 6h;
          send_timeout 6h;
        '';
      };
      # verto.nginx
      locations."/verto" = {
        proxyPass = "http://127.0.0.1:8082";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 6h;
          proxy_send_timeout 6h;
          client_body_timeout 6h;
          send_timeout 6h;
        '';
      };
      # web.nginx
      locations."/bigbluebutton" = {
        proxyPass = "http://127.0.0.1:8090";
        extraConfig = ''
          proxy_redirect default;
          add_header P3P 'CP="No P3P policy available"';
        '';
      };
      locations."~ \"^\\/bigbluebutton\\/presentation\\/(?<prestoken>[a-zA-Z0-9_-]+)/upload$\"" = {
        proxyPass = "http://127.0.0.1:8090";
        extraConfig = ''
          proxy_redirect default;
          add_header P3P 'CP="No P3P policy available"';

          client_max_body_size 30m;

          proxy_buffer_size 4k;
          proxy_buffers 4 32k;
          proxy_busy_buffers_size 64k;
          proxy_temp_file_write_size 64k;

          include ${config.services.nginx.package}/conf/fastcgi.conf;

          proxy_request_buffering off;
          auth_request /bigbluebutton/presentation/checkPresentation;
        '';
      };
      locations."/bigbluebutton/presentation/checkPresentation" = {
        proxyPass = "http://127.0.0.1:8090";
        extraConfig = ''
          proxy_redirect default;

          proxy_set_header X-Presentation-Token $prestoken;
          proxy_set_header X-Original-URI $request_uri;
          proxy_set_header Content-Length "";
          proxy_set_header X-Original-Content-Length $http_content_length;

          client_max_body_size 30m;

          proxy_pass_request_body off;
          proxy_request_buffering off;
        '';
      };
      locations."/bigbluebutton/connection/checkAuthorization" = {
        proxyPass = "http://127.0.0.1:8090";
        extraConfig = ''
          internal;

          proxy_pass_request_body off;
          proxy_set_header Content-Length "";
          proxy_set_header X-Original-URI $request_uri;
        '';
      };
      # webrtc-sfu.nginx
      locations."/bbb-webrtc-sfu" = {
        proxyPass = "http://127.0.0.1:3008";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 6h;
          proxy_send_timeout 6h;
          client_body_timeout 6h;
          send_timeout 6h;
        '';
      };

      # greenlight
      locations."/b" = {
        proxyPass = "http://127.0.0.1:${toString config.services.bigbluebutton.greenlight.port}";
      };

      locations."/b/cable" = {
        proxyPass = "http://127.0.0.1:${toString config.services.bigbluebutton.greenlight.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 6h;
          proxy_send_timeout 6h;
          client_body_timeout 6h;
          send_timeout 6h;
        '';
      };

      locations."= /".extraConfig = ''
        return 307 /b/signin;
      '';
      locations."= /b".extraConfig = ''
        if ($request_method = GET) {
          return 307 /b/signin;
        }
        if ($request_method != GET) {
          proxy_pass http://127.0.0.1:${toString config.services.bigbluebutton.greenlight.port};
        }
      '';
      locations."= /b/".extraConfig = ''
        if ($request_method = GET) {
          return 307 /b/signin;
        }
        if ($request_method != GET) {
          proxy_pass http://127.0.0.1:${toString config.services.bigbluebutton.greenlight.port};
        }
      '';
    };

    systemd.services.nginx.apparmor.extraConfig = ''
      /var/lib/bigbluebutton/** r,
    '';

    # Group that is allowed to read recordings.
    # Will later be used for the record processes.
    users.groups.bbb-record = {};

    helsinki.firewall.ports.udp = [
      "24577-32768" # WebRTC video
    ];
  };
}
