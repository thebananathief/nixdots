{ config, pkgs, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  # services = {
  #   sonarr = {
  #     enable = true;
  #     openFirewall = false;
  #     user = "sonarr";
  #     group = mediaGroup;
  #   };
  #   radarr = {
  #     enable = true;
  #     openFirewall = false;
  #     user = "radarr";
  #     group = mediaGroup;
  #   };
  #   prowlarr = {
  #     enable = true;
  #     openFirewall = false;
  #   };
  #   flaresolverr = {
  #     enable = true;
  #     openFirewall = false;
  #     port = 8191;
  #   };
  # };

  users = {
    groups.prowlarr = {};
    users.prowlarr = {
      uid = 985;
      group = "prowlarr";
      isSystemUser = true;
    };
    groups.sonarr = {};
    users.sonarr = {
      uid = 984;
      group = "sonarr";
      isSystemUser = true;
    };
    groups.radarr = {};
    users.radarr = {
      uid = 983;
      group = "radarr";
      isSystemUser = true;
    };
  };

  virtualisation.oci-containers.containers = {
    # Media indexing, metadata and organizing, coordinating
    flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      ports = ["8191:8191"];
      environment = {
        LOG_LEVEL = "info";
      };
      extraOptions = [
        "--network=media"
      ];
    };
    prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      volumes = [
        "${cfg.dataDir}/prowlarr:/config"
      ];
      ports = ["9696:9696"];
      environment = {
        PUID = "${config.users.prowlarr.uid}"; # prowlarr
        PGID = "${config.users.${cfg.mediaGroup}.gid}"; # media
      } ++ cfg.common_env;
      extraOptions = [
        "--network=media"
      ];
    };
    radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      volumes = [
        "${cfg.dataDir}/radarr:/config"
        "${cfg.storageDir}:/storage"
      ];
      ports = ["7878:7878"];
      environment = {
        PUID = "${config.users.radarr.uid}"; # radarr
        PGID = "${config.users.${cfg.mediaGroup}.gid}"; # media
      } ++ cfg.common_env;
      extraOptions = [
        "--network=media"
      ];
    };
    sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      volumes = [
        "${cfg.dataDir}/sonarr:/config"
        "${cfg.storageDir}:/storage"
      ];
      ports = ["8989:8989"];
      environment = {
        PUID = "${config.users.sonarr.uid}"; # sonarr
        PGID = "${config.users.${cfg.mediaGroup}.gid}"; # media
      } ++ cfg.common_env;
      extraOptions = [
        "--network=media"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/sonarr 0775 sonarr media -"
    "d /var/lib/sonarr/.config 0775 sonarr media -"
    "d ${config.services.sonarr.dataDir} 0775 sonarr media -"

    "d /var/lib/radarr 0775 radarr media -"
    "d /var/lib/radarr/.config 0775 radarr media -"
    "d ${config.services.radarr.dataDir} 0775 radarr media -"
  ];
  
  services.caddy.virtualHosts = {
    # Prowlarr
    "prowlarr.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:9696
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
    # Sonarr
    "sonarr.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8989
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
    # Radarr
    "radarr.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:7878
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}