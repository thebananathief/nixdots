{ config, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
  configFile = builtins.toJSON [
    {
      category = "Services";
      services = [
        {
          name = "Archivebox";
          uri = "https://archivebox.mywebsite.com";
          description = "Backup webpages";
          icon = "/icons/archivebox.jpg";
        }
        {
          name = "Authelia";
          uri = "https://auth.mywebsite.com";
          description = "Authentication";
          icon = "/icons/authelia.png";
        }
        {
          name = "Calibre";
          uri = "https://calibre.mywebsite.com";
          description = "eBook library";
          icon = "/icons/calibre.png";
        }
      ];
    }
    {
      category = "Devices";
      bubble = true;
      services = [
        {
          name = "Router";
          uri = "http://192.168.1.1/";
          description = "Netgear Orbi";
          icon = "/icons/router.png";
        }
        {
          name = "Home Assistant";
          uri = "http://homeassistant.local:8123/";
          description = "Home automation";
          icon = "home-assistant";
          iconBubble = false;
        }
        {
          name = "Synology";
          uri = "http://synology:5000";
          description = "Network storage";
          icon = "/icons/synology.png";
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