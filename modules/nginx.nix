{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.services.bigbluebutton.nginx;
in {
  options.services.bigbluebutton.nginx = with types; let
    mkUrlOpt = name: mkOption {
      description = "URL for BigBlueButton ${name} upstream";
      type = str;
    };
  in {
    enable = mkEnableOption "the nginx webserver config for BigBlueButton";

    domain = mkOption {
      description = "Domain name of the virtualhost";
      type = str;
    };

    virtualHost = mkOption {
      description = "Name of the virtualhost. You probably don't want to change this.";
      type = str;
      default = "bigbluebutton";
    };

    etherpadUrl = mkUrlOpt "etherpad";
    freeswitchVertoUrl = mkUrlOpt "FreeSwitch Verto";
    freeswitchWs = {
      scheme = mkOption {
        type = str;
        description = "FreeSwitch WebSocket scheme";
        default = "https";
      };
      port = mkOption {
        type = port;
        description = "FreeSwitch WebSocket port";
        default = 7443;
      };
      ips = mkOption {
        type = listOf str;
        description = "FreeSwitch WebSocket IPs. Read https://github.com/bigbluebutton/bigbluebutton/issues/9295 for why this is a thing.";
      };
    };
    greenlightUrl = mkUrlOpt "greenlight";
    html5Url = mkUrlOpt "html";
    webUrl = mkUrlOpt "web";
    webrtcSfuUrl = mkUrlOpt "webrtc sfu";
  };

  config = mkIf cfg.enable {
    # https://github.com/bigbluebutton/bigbluebutton/issues/9295
    services.nginx.appendHttpConfig = let
      v4 = filter (x: !(hasInfix ":" x)) cfg.freeswitchWs.ips;
      v6 = filter (hasInfix ":") cfg.freeswitchWs.ips;
    in ''
      map $remote_addr $freeswitch_addr {
        "~:"    [${head v6}];
        default ${head v4};
      }
    '';

    services.nginx.virtualHosts."${cfg.virtualHost}" = {
      serverName = cfg.domain;

      # bbb-html5.nginx
      locations."/html5client" = {
        proxyPass = cfg.html5Url;
        proxyWebsockets = true;
      };
      locations."/_timesync" = {
        proxyPass = cfg.html5Url;
      };

      # notes.nginx
      locations."~ \"^\\/pad\\/p\\/(\\w+)$\"" = {
        proxyPass = cfg.etherpadUrl;
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
        proxyPass = cfg.etherpadUrl;
        extraConfig = ''
          rewrite /pad/(.*) /$1 break;
          rewrite ^/pad$ /pad/ permanent;
          proxy_pass_header Server;
          proxy_redirect / /pad;
          proxy_buffering off;
        '';
      };
      locations."/pad/socket.io" = {
        proxyPass = cfg.etherpadUrl;
        proxyWebsockets = true;
        extraConfig = ''
          rewrite /pad/socket.io/(.*) /socket.io/$1 break;
          proxy_redirect / /pad/;
          proxy_buffering off;
        '';
      };
      locations."/static" = {
        proxyPass = cfg.etherpadUrl;
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
        root = pkgs.bbbPackages.recordAndPlaybackPresentation;
        index = "index.html index.htm";
      };
      locations."/presentation" = {
        root = "/var/lib/bigbluebutton/published";
        index = "index.html index.htm";
      };

      # sip.nginx
      locations."/ws" = {
        proxyPass = "${cfg.freeswitchWs.scheme}://$freeswitch_addr:${toString cfg.freeswitchWs.port}";
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
        proxyPass = cfg.freeswitchVertoUrl;
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
        proxyPass = cfg.webUrl;
        extraConfig = ''
          proxy_redirect default;
          add_header P3P 'CP="No P3P policy available"';
        '';
      };
      locations."~ \"^\\/bigbluebutton\\/presentation\\/(?<prestoken>[a-zA-Z0-9_-]+)/upload$\"" = {
        proxyPass = cfg.webUrl;
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
        proxyPass = cfg.webUrl;
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
        proxyPass = cfg.webUrl;
        extraConfig = ''
          internal;

          proxy_pass_request_body off;
          proxy_set_header Content-Length "";
          proxy_set_header X-Original-URI $request_uri;
        '';
      };

      # webrtc-sfu.nginx
      locations."/bbb-webrtc-sfu" = {
        proxyPass = cfg.webrtcSfuUrl;
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
        proxyPass = cfg.greenlightUrl;
      };

      locations."/b/cable" = {
        proxyPass = cfg.greenlightUrl;
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
          proxy_pass ${cfg.greenlightUrl};
        }
      '';
      locations."= /b/".extraConfig = ''
        if ($request_method = GET) {
          return 307 /b/signin;
        }
        if ($request_method != GET) {
          proxy_pass ${cfg.greenlightUrl};
        }
      '';
    };

    systemd.services.nginx = {
      serviceConfig.SupplementaryGroups = "bbb-record";
      apparmor.extraConfig = ''
        /var/lib/bigbluebutton/** r,
      '';
    };
  };
}
