{ config, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
  configFile = builtins.toJSON [
    {
      category = "Media";
      services = [
        {
          name = "Sonarr";
          uri = "https://sonarr.talos.host/";
          description = "TV Show fetching manager";
          icon = "sonarr";
        }
        {
          name = "Radarr";
          uri = "https://auth.mywebsite.com";
          description = "Movie fetching manager";
          icon = "radarr";
        }
        {
          name = "Prowlarr";
          uri = "https://prowlarr.talos.host/";
          description = "Torrent indexer manager/aggregator";
          icon = "prowlarr";
        }
        {
          name = "Transmission";
          uri = "http://transmission.talos.host/";
          description = "BitTorrent client";
          icon = "hl-transmission";
        }
        {
          name = "Jellyseerr";
          uri = "http://request.talos.host/";
          description = "Request media";
          icon = "jellyseerr";
        }
        {
          name = "Jellyfin";
          uri = "http://watch.talos.host/";
          description = "Movie/Show player and manager";
          icon = "jellyfin";
        }
        {
          name = "Audiobookshelf";
          uri = "https://books.talos.host/";
          description = "Audiobook/podcast player and manager";
          icon = "audiobookshelf";
        }
        # {
        #   name = "Immich";
        #   uri = "http://talos:8014/";
        #   description = "Photos";
        #   icon = "immich";
        # }
      ];
    }
    {
      category = "Services";
      services = [
        {
          name = "Grafana";
          uri = "https://grafana.talos.host/";
          description = "Monitor system stats";
          icon = "grafana";
        }
        {
          name = "Librespeed";
          uri = "http://speedtest.talos.host/";
          description = "Speedtest against TALOS";
          icon = "hl-librespeed";
        }
        {
          name = "Gitea";
          uri = "http://code.talos.host/";
          description = "Local source code";
          icon = "hl-gitea";
        }
        # {
        #   name = "Smokeping";
        #   uri = "http://talos:8015/";
        #   description = "Pings various services constantly";
        #   icon = "hl-smokeping";
        # }
        # {
        #   name = "TTRSS";
        #   uri = "https://rss.talos.host/";
        #   description = null;
        #   icon = "hl-tinytinyrss";
        # }
        # {
        #   name = "Webtrees";
        #   uri = "http://talos:8013/";
        #   description = "Geneology database";
        #   icon = "webtrees-logo.png";
        # }
        # {
        #   name = "Scrutiny";
        #   uri = "http://talos:8007/web/dashboard";
        #   description = "S.M.A.R.T Info for HDDs";
        #   icon = "hl-scrutiny";
        # }
        # {
        #   name = "Dozzle";
        #   uri = "http://talos:8008/";
        #   description = "View logs from docker containers";
        #   icon = "hl-dozzle";
        # }
        # {
        #   name = "Uptime Kuma";
        #   uri = "http://talos:8017/";
        #   description = "Monitor things";
        #   icon = "hl-uptimekuma";
        # }
      ];
    }
    {
      category = "Devices";
      bubble = true;
      services = [
        {
          name = "Router";
          uri = "http://192.168.0.1/";
          description = "Local gateway interface";
          icon = "router";
          # icon = "/icons/synology.png";
        }
        {
          name = "Styx";
          uri = "https://styx/login/";
          description = "KVM server";
          icon = "pikvm";
        }
        # {
        #   name = "Home Assistant";
        #   uri = "http://homeassistant.local:8123/";
        #   description = "Home automation";
        #   icon = "home-assistant";
        #   iconBubble = false;
        # }
      ];
    }
    {
      category = "External Services";
      services = [
        {
          name = "Cloudflare";
          uri = "https://dash.cloudflare.com/";
          description = "Cloudflare dashboard";
          icon = "cloudflare";
        }
        {
          name = "Namecheap";
          uri = "https://ap.www.namecheap.com/dashboard";
          description = "Domain registrar";
          icon = "namecheap";
        }
        {
          name = "Healthchecks.io";
          uri = "https://healthchecks.io/projects/c5e9aa12-7ba8-4c6b-877c-6324ef44c349/checks/";
          description = "Job / Uptime checking and notifications";
          icon = "healthcheck";
        }
      ];
    }
  ];
in {
  users = {
    groups.starbase = { gid = 970; };
    users.starbase = {
      uid = 980;
      group = "starbase";
      isSystemUser = true;
    };
  };

  virtualisation.oci-containers.containers = {
    starbase80 = {
      image = "jordanroher/starbase-80:latest";
      volumes = [
        "${ cfg.dataDir }/starbase/config.json:/app/src/config/config.json"
        "${ cfg.dataDir }/starbase/public/favicon.ico:/app/public/favicon.ico"
        "${ cfg.dataDir }/starbase/public/logo.png:/app/public/logo.png"
        "${ cfg.dataDir }/starbase/public/icons:/app/public/icons"
      ];
      ports = [ "8002:4173" ];
      # user = "980:970";
      environment = {
        TITLE = "Talos Home";
        LOGO = "/starbase80.jpg";
      };
    };
  };

  system.activationScripts.starbaseSetup = ''
    mkdir -p ${ cfg.dataDir }/starbase/public/icons
    echo '${configFile}' > ${ cfg.dataDir }/starbase/config.json
    chown -R starbase:starbase ${ cfg.dataDir }/starbase
    chmod -R 750 ${ cfg.dataDir }/starbase
  '';
  
  # systemd.tmpfiles.rules = [
  #   "d ${ cfg.dataDir }/starbase 0755 starbase starbase - -"
  #   "d ${ cfg.dataDir }/starbase/public 0755 starbase starbase - -"
  # ];
  
  services.caddy.virtualHosts = {
    "base.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8002
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}