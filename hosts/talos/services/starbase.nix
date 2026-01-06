{ config, pkgs, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
  configFileContent = builtins.toJSON [
    # Icons reference: https://github.com/notclickable-jordan/starbase-80?tab=readme-ov-file#icons
    # https://dashboardicons.com/
    {
      category = "Media";
      services = [
        {
          name = "Sonarr";
          uri = "http://sonarr.${ config.networking.fqdn }/";
          description = "TV Show fetching manager";
          icon = "sonarr";
        }
        {
          name = "Radarr";
          uri = "http://radarr.${ config.networking.fqdn }/";
          description = "Movie fetching manager";
          icon = "radarr";
        }
        {
          name = "Prowlarr";
          uri = "http://prowlarr.${ config.networking.fqdn }/";
          description = "Torrent indexer manager/aggregator";
          icon = "prowlarr";
        }
        {
          name = "Transmission";
          uri = "http://transmission.${ config.networking.fqdn }/";
          description = "BitTorrent client";
          icon = "transmission";
        }
        {
          name = "Jellyseerr";
          uri = "https://request.${ config.networking.publicDomain }/";
          description = "Request media";
          icon = "jellyseerr";
        }
        {
          name = "Jellyfin";
          uri = "https://watch.${ config.networking.publicDomain }/";
          description = "Movie/Show player and manager";
          icon = "jellyfin";
        }
        {
          name = "Audiobookshelf";
          uri = "https://books.${ config.networking.publicDomain }/";
          description = "Audiobook/podcast player and manager";
          icon = "audiobookshelf";
        }
        {
          name = "Immich";
          uri = "https://photos.${ config.networking.publicDomain }/";
          description = "Photos";
          icon = "immich";
        }
      ];
    }
    {
      category = "Services";
      services = [
        {
          name = "Syncthing";
          uri = "http://syncthing.${ config.networking.fqdn }/";
          description = "Sync folder";
          icon = "syncthing";
        }
        {
          name = "Home Assistant";
          uri = "http://homeassistant.local:8123/";
          description = "Smart home stuff";
          icon = "home-assistant";
        }
        # {
        #   name = "Music Assistant";
        #   uri = "http://homeassistant.local:8095/";
        #   description = "Self hosted music frontend";
        #   icon = "music-assistant";
        # }
        {
          name = "Grafana";
          uri = "http://grafana.${ config.networking.fqdn }/";
          description = "Monitor system stats";
          icon = "grafana";
        }
        {
          name = "Prometheus";
          uri = "http://prometheus.${ config.networking.fqdn }/";
          description = "Sketch prometheus queries";
          icon = "prometheus";
        }
        # {
        #   name = "Perses";
        #   uri = "http://perses.${ config.networking.fqdn }/";
        #   description = "Dashboarding tool";
        #   icon = "perses";
        # }
        # {
        #   name = "InfluxDB2";
        #   uri = "http://${ config.networking.fqdn }:8086/";
        #   description = "Time series database web UI";
        #   icon = "influxdb";
        # }
        {
          name = "Librespeed";
          uri = "http://speedtest.${ config.networking.fqdn }/";
          description = "Speedtest against TALOS";
          icon = "librespeed";
        }
        {
          name = "Smokeping";
          uri = "http://smokeping.${ config.networking.fqdn }/";
          description = "Ping over time stats";
          icon = "smokeping";
        }
        {
          name = "Gitea";
          uri = "http://code.${ config.networking.fqdn }/";
          description = "Local source code";
          icon = "gitea";
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
        #   icon = "/icons/webtrees-logo.png";
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
      services = [
        {
          name = "Router";
          uri = "http://192.168.0.1/";
          description = "Local gateway interface";
          icon = "router";
          # icon = "/icons/synology.png";
        }
        {
          name = "Access Point";
          uri = "http://192.168.0.50/";
          description = "AP interface";
          icon = "router";
          # icon = "/icons/synology.png";
        }
        {
          name = "Styx - piKVM";
          uri = "https://styx/login/";
          description = "KVM server";
          icon = "pikvm-light";
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
      bubble = true;
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
          icon = "icons/namecheap-logo.png";
        }
        {
          name = "Healthchecks.io";
          uri = "https://healthchecks.io/projects/c5e9aa12-7ba8-4c6b-877c-6324ef44c349/checks/";
          description = "Job / Uptime checking and notifications";
          icon = "healthchecks";
        }
        {
          name = "Github";
          uri = "https://github.com/thebananathief?tab=repositories/";
          description = "Personal github";
          icon = "github-light";
        }
      ];
    }
  ];

  starbaseConfigInStore = pkgs.writeText "starbase-config.json" configFileContent;
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
        "${ starbaseConfigInStore }:/app/src/config/config.json:ro"
        "${ cfg.dataDir }/starbase/public/favicon.ico:/app/public/favicon.ico"
        "${ cfg.dataDir }/starbase/public/logo.png:/app/public/logo.png"
        "${ cfg.dataDir }/starbase/public/icons:/app/public/icons"
      ];
      ports = [ "8000:4173" ];
      # podman.user = "starbase:starbase";
      # user = "980:970";
      environment = {
        # TITLE = "Talos Home"; 
        # LOGO = "/icons/logo.png";
        # LOGO = "xcp-ng";
        HEADER = "false";
        HOVER = "underline";
      };
    };
  };

  systemd.services."podman-starbase80".restartTriggers = [
    starbaseConfigInStore
  ];

  system.activationScripts.starbaseSetup = ''
    mkdir -p ${ cfg.dataDir }/starbase/public/icons
    chown -R starbase:starbase ${ cfg.dataDir }/starbase
    chmod -R 750 ${ cfg.dataDir }/starbase
  '';
  
  # systemd.tmpfiles.rules = [
  #   "d ${ cfg.dataDir }/starbase 0755 starbase starbase - -"
  #   "d ${ cfg.dataDir }/starbase/public 0755 starbase starbase - -"
  # ];
  
  services.caddy.virtualHosts = {
    # Bind to local network interface only
    # bind 192.168.0.0/24
    "${ config.networking.fqdn }".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy 127.0.0.1:8000
    '';
  };
}
