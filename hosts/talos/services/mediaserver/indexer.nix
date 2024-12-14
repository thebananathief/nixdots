{ config, pkgs, ... }:
let
  cfg = config.myOptions.containers;
  mediaGroup = config.myOptions.mediaGroup;
  inherit (config.sops) secrets;
  mediaserver_env = {
    PUID = "989"; # mediaserver
    PGID = "131"; # docker
    TZ = config.time.timeZone;
  };
in {
  systemd.tmpfiles.rules = [
    "d ${config.services.sonarr.dataDir} 0775 sonarr media -"
    "d ${config.services.radarr.dataDir} 0775 radarr media -"
    "d ${cfg.storageDir}/downloads 0775 torrenter media -"
    "d ${cfg.storageDir}/downloads/complete 0775 torrenter media -"
    "d ${cfg.storageDir}/downloads/incomplete 0775 torrenter media -"
  ];

  services = {
    sonarr = {
      enable = true;
      openFirewall = false;
      user = "sonarr";
      group = mediaGroup;
    };
    radarr = {
      enable = true;
      openFirewall = false;
      user = "radarr";
      group = mediaGroup;
    };
    prowlarr = {
      enable = true;
      openFirewall = false;
    };
    flaresolverr = {
      enable = true;
      openFirewall = false;
      port = 8191;
    };
  };

  # virtualisation.oci-containers.containers = {
  #   # Media indexing, metadata and organizing, coordinating
  #   # flaresolverr = {
  #   #   image = "ghcr.io/flaresolverr/flaresolverr:latest";
  #   #   ports = ["8191:8191"];
  #   #   environment = {
  #   #     LOG_LEVEL = "info";
  #   #   };
  #   #   extraOptions = [
  #   #     "--network=media"
  #   #   ];
  #   # };
  #   # prowlarr = {
  #   #   image = "lscr.io/linuxserver/prowlarr:latest";
  #   #   volumes = [
  #   #     "${cfg.dataDir}/prowlarr:/config"
  #   #   ];
  #   #   ports = ["8002:9696"];
  #   #   environment = mediaserver_env;
  #   #   extraOptions = [
  #   #     "--network=media"
  #   #   ];
  #   # };
  #   # radarr = {
  #   #   image = "lscr.io/linuxserver/radarr:latest";
  #   #   volumes = [
  #   #     "${cfg.dataDir}/radarr:/config"
  #   #     "${cfg.storageDir}:/storage"
  #   #   ];
  #   #   ports = ["8003:7878"];
  #   #   environment = mediaserver_env;
  #   #   extraOptions = [
  #   #     "--network=media"
  #   #   ];
  #   # };
  #   # sonarr = {
  #   #   image = "lscr.io/linuxserver/sonarr:latest";
  #   #   volumes = [
  #   #     "${cfg.dataDir}/sonarr:/config"
  #   #     "${cfg.storageDir}:/storage"
  #   #   ];
  #   #   ports = ["8004:8989"];
  #   #   environment = mediaserver_env;
  #   #   extraOptions = [
  #   #     "--network=media"
  #   #   ];
  #   # };
  # };
  
  services.caddy.virtualHosts = {
    # Prowlarr
    "prowlarr.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8002
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