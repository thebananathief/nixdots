{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  main_domain = secrets.main_domain.path;
in {
  virtualisation.oci-containers.containers = {
    # Media players
    # plex = {
    #   image = "lscro.io/linuxserver/plex:latest"; # https://hub.docker.com/r/linuxserver/plex/
    #   volumes = [
    #     "${ cfg.dataDir }/plex:/config"
    #     "${ cfg.storageDir }/media:/media"
    #     "/etc/localtime:/etc/localtime:ro"
    #   ];
    #   environment = {
    #     PLEX_CLAIM = "nope";
    #     VERSION = "docker";
    #   } // cfg.common_env;
    #   extraOptions = [
    #     "--network=host"
    #     "--device=/dev/dri:/dev/dri"
    #   ];
    # };
    jellyfin = {
      image = "jellyfin/jellyfin";
      volumes = [
        "${ cfg.dataDir }/jellyfin:/config"
        "${ cfg.storageDir }/media:/data"
        # "/dev/shm:/transcode" # ram transcode
      ];
      ports = [
        "8096:8096"
        # "8920:8920" # HTTPS web interface
        "7359:7359/udp" # Optional - Allows clients to discover Jellyfin on the local network.
        "1900:1900/udp" # Optional - Service discovery used by DNLA and clients.
      ];
      environment = {
        JELLYFIN_PublishedServerUrl = "watch.${ main_domain }";
      } // cfg.common_env;
      extraOptions = [
        "--network=bridge"
        "--device=/dev/dri:/dev/dri"
      ];
      # labels = {
      #   "traefik.enable" = true;
      #   "traefik.http.routers.jellyfin.rule" = "Host(`watch.${ main_domain }`)";
      #   "traefik.http.routers.jellyfin.entrypoints" = "websecure";
      #   "traefik.http.services.jellyfin.loadbalancer.server.port" = 8096;
      # };
      # user = "cameron:docker";
    };

    # Media requesters
    requestrr = {
      image = "lscr.io/linuxserver/requestrr:latest"; # https://hub.docker.com/r/linuxserver/requestrr
      volumes = [
        "${ cfg.dataDir }/requestrr:/config"
      ];
      ports = [ "8006:4545" ];
      environment = cfg.common_env;
      extraOptions = [
        "--network=bridge"
      ];
    };
    jellyseerr = {
      image = "fallenbagel/jellyseerr:latest";
      volumes = [
        "${ cfg.dataDir }/jellyseerr:/app/config"
      ];
      ports = [ "8005:5055" ];
      environment = {
        LOG_LEVEL = "debug";
      } // cfg.common_env;
      extraOptions = [
        "--network=bridge"
      ];
      # labels = {
      #   "traefik.enable" = true;
      #   "traefik.http.routers.overseerr.rule" = "Host(`request.${ main_domain }`)";
      #   "traefik.http.routers.overseerr.entrypoints" = "websecure";
      # };
    };
    # overseerr = {
    #   image = "lscr.io/linuxserver/overseerr:latest";
    #   volumes = [
    #     "${ cfg.dataDir }/overseerr:/config"
    #   ];
    #   ports = [ "8005:5055" ];
    #   environment = cfg.common_env;
    #   # extraOptions = [
    #   #   "--network=public_access";
    #   # ];
    #   # labels = {
    #   #   "traefik.enable" = true;
    #   #   "traefik.http.routers.overseerr.rule" = "Host(`request.${ main_domain }`)";
    #   #   "traefik.http.routers.overseerr.entrypoints" = "websecure";
    #   # };
    # };

    # Media indexing, metadata and organizing, coordinating
    prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      volumes = [
        "${ cfg.dataDir }/prowlarr:/config"
      ];
      ports = [ "8002:9696" ];
      environment = cfg.common_env;
      extraOptions = [
        "--network=bridge"
      ];
    };
    radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      volumes = [
        "${ cfg.dataDir }/radarr:/config"
        "${ cfg.storageDir }:/storage"
      ];
      ports = [ "8003:7878" ];
      environment = cfg.common_env;
      extraOptions = [
        "--network=bridge"
      ];
    };
    sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      volumes = [
        "${ cfg.dataDir }/sonarr:/config"
        "${ cfg.storageDir }:/storage"
      ];
      ports = [ "8004:8989" ];
      environment = cfg.common_env;
      extraOptions = [
        "--network=bridge"
      ];
    };

    # VPN and download client
    # https://github.com/qdm12/gluetun-wiki/
    gluetun = {
      image = "docker.io/qmcgaw/gluetun:v3";
      volumes = [
        "${ cfg.dataDir }/gluetun:/gluetun"
      ];
      environmentFiles = [
        secrets."mullvad.env".path # WIREGUARD_PRIVATE_KEY
      ];
      environment = {
        VPN_SERVICE_PROVIDER = "mullvad";
        VPN_TYPE = "wireguard";
        # WIREGUARD_PRIVATE_KEY = "$mullvad_privKey"; # For some reason this doesn't parse right
        WIREGUARD_ADDRESSES = "10.67.197.145/32";
        SERVER_COUNTRIES = "Switzerland";
        # OWNED_ONLY = "yes"; # Use if you want only servers owned by Mullvad
      };
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun:/dev/net/tun"
      ];
      # NOTE: Any containers using the gluetun network stack need to
      # have portforwards set here instead of that container
      ports = [ 
        "8001:9091" # transmission web ui
        "51413:51413" # torrent ports ?
        "51413:51413/udp"
      ];
    };
    transmission = {
      image = "lscr.io/linuxserver/transmission:latest ";
      volumes = [
        "${ cfg.dataDir }/transmission:/config"
        "${ cfg.downloadDir }:/downloads"
        "${ cfg.downloadDir }:/watch" # TODO: Adjust this to a torrent blackhole
      ];
      environment = {
        # WHITELIST = "192.168.0.0/24";
        # TRANSMISSION_WEB_HOME = "";
      } // cfg.common_env;
      # This uses the gluetun network stack so that its behind VPN
      extraOptions = [ "--network=container:gluetun" ];
      dependsOn = [ "gluetun" ];
    };
  };
}