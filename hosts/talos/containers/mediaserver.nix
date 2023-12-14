{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  virtualisation.oci-containers.containers = {
    # Media players
    plex = {
      image = "lscro.io/linuxserver/plex:latest"; # https://hub.docker.com/r/linuxserver/plex/
      volumes = [
        "${ cfg.dataDir }/plex:/config"
        "${ cfg.storageDir }/media:/media"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        PLEX_CLAIM = "nope";
        VERSION = "docker";
      } ++ cfg.common_env;
      extraOptions = [
        "--network=host"
        "--device=/dev/dri:/dev/dri"
      ];
    };
    jellyfin = {
      image = "jellyfin/jellyfin";
      volumes = [
        "${ cfg.dataDir }/jellyfin:/config"
        "${ cfg.storageDir }/media:/data"
        # "/dev/shm:/transcode" # ram transcode
      ];
      environment = {
        JELLYFIN_PublishedServerUrl = "watch.${ main_domain }";
      } ++ cfg.common_env;
      extraOptions = [
        # "--network=public_access"
        "--device=/dev/dri:/dev/dri"
      ];
      labels = {
        "traefik.enable" = true;
        "traefik.http.routers.jellyfin.rule" = "Host(`watch.${ main_domain }`)";
        "traefik.http.routers.jellyfin.entrypoints" = "websecure";
        "traefik.http.services.jellyfin.loadbalancer.server.port" = 8096;
      };
    };

    # Media requesters
    requestrr = {
      image = "lscr.io/linuxserver/requestrr:latest"; # https://hub.docker.com/r/linuxserver/requestrr
      volumes = [
        "${ cfg.dataDir }/requestrr:/config"
      ];
      ports = [ "4545:4545" ];
      environment = cfg.common_env;
    };
    overseerr = {
      image = "lscr.io/linuxserver/overseerr:latest";
      volumes = [
        "${ cfg.dataDir }/overseerr:/config"
      ];
      environment = cfg.common_env;
      # extraOptions = [
      #   "--network=public_access";
      # ];
      labels = {
        "traefik.enable" = true;
        "traefik.http.routers.overseerr.rule" = "Host(`request.${ main_domain }`)";
        "traefik.http.routers.overseerr.entrypoints" = "websecure";
      };
    };

    # Media indexing, metadata and organizing, coordinating
    prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      volumes = [
        "${ cfg.dataDir }/prowlarr:/config"
      ];
      ports = [ "9696:9696" ];
      environment = cfg.common_env;
    };
    radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      volumes = [
        "${ cfg.dataDir }/radarr:/config"
        "${ cfg.storageDir }:/storage"
      ];
      ports = [ "7878:7878" ];
      environment = cfg.common_env;
    };
    sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      volumes = [
        "${ cfg.dataDir }/sonarr:/config"
        "${ cfg.storageDir }:/storage"
      ];
      ports = [ "8989:8989" ];
      environment = cfg.common_env;
    };

    # VPN and download client
    # https://github.com/qdm12/gluetun-wiki/
    gluetun = {
      image = "qmcgaw/gluetun:latest";
      environment = {
        VPN_SERVICE_PROVIDER = "mullvad";
        VPN_TYPE = "wireguard";
        WIREGUARD_PRIVATE_KEY = "${ mullvad_privKey }";
        WIREGUARD_ADDRESSES = "10.67.197.145/32";
        SERVER_COUNTRIES = "Switzerland";
        # OWNED_ONLY = "yes"; # Use if you want only servers owned by Mullvad
      };
      extraOptions = [ "--cap-add=NET_ADMIN" ];
      # NOTE: Any containers using the gluetun network stack need to
      # have portforwards set here instead of that container
      ports = [ 
        "9092:9091" # transmission web ui
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
      } ++ cfg.common_env;
      # This uses the gluetun network stack so that its behind VPN
      extraOptions = [ "--network=container:gluetun" ];
    };

    # transmission = {
    #   image = "haugene/transmission-openvpn:latest";
    #   volumes = [
    #     "/etc/localtime:/etc/localtime:ro"
    #     "${ cfg.downloadDir }:/data"
    #   ];
    #   ports = [ "9092:9091" ];
    #   environment = {
    #     PUID = "${ main_uid }";
    #     PGID = "${ main_gid }";
    #     OPENVPN_PROVIDER = "NORDVPN";
    #     NORDVPN_COUNTRY = "US";
    #     NORDVPN_CATEGORY = "legacy_p2p";
    #     OPENVPN_USERNAME = "${ nordvpn_user }";
    #     OPENVPN_PASSWORD = "${ nordvpn_pass }";
    #     OPENVPN_OPTS = "--inactive 3600 --ping 10 --ping-exit 60";
    #     LOCAL_NETWORK = "192.168.0.0/24";
    #     # TRANSMISSION_WEB_UI = "combustion";
    #   };
    #   extraOptions = [
    #     "--cap-add=NET_ADMIN"
    #     "--device=/dev/net/tun"
    #     "--dns=8.8.8.8"
    #     "--dns=8.8.4.4"
    #   ];
    # };
  };
}