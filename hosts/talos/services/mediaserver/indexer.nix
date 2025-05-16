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
      uid = 274;
      group = "sonarr";
      isSystemUser = true;
    };
    groups.radarr = {};
    users.radarr = {
      uid = 275;
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
        PUID = "985"; # prowlarr
        PGID = "987"; # media
      } // cfg.common_env;
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
        PUID = "275"; # radarr
        PGID = "987"; # media
      } // cfg.common_env;
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
        PUID = "274"; # sonarr
        PGID = "987"; # media
      } // cfg.common_env;
      extraOptions = [
        "--network=media"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/sonarr 0755 sonarr sonarr - -"
    "d /var/lib/sonarr/.config 0755 sonarr sonarr - -"
    "d ${config.services.sonarr.dataDir} 0755 sonarr sonarr - -"
    "d ${cfg.storageDir}/media/tv 0775 sonarr media - -"

    "d /var/lib/radarr 0755 radarr radarr - -"
    "d /var/lib/radarr/.config 0755 radarr radarr - -"
    "d ${config.services.radarr.dataDir} 0755 radarr radarr - -"
    "d ${cfg.storageDir}/media/movies 0775 radarr media - -"
  ];
  
  # Create the Docker network
  systemd.services.docker-network-penpot = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" "docker.socket" ];
    script = ''
      # Create network if it doesn't exist
      ${pkgs.docker}/bin/docker network inspect media >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create media
    '';
  };
  
  services.caddy.virtualHosts = {
    # Prowlarr
    "prowlarr.${ config.networking.fqdn }".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:9696
    '';
    # Sonarr
    "sonarr.${ config.networking.fqdn }".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:8989
    '';
    # Radarr
    "radarr.${ config.networking.fqdn }".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:7878
    '';
  };
}