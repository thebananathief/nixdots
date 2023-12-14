{ 
  appdata_path,
  storage_path,
  download_path,
  main_domain,
  linuxserver_env,
  main_uid,
  main_gid,
  mullvad_privKey,
  ...
}:
let
  paths = {
    appdata = "/var/appdata";
    downloads = "/mnt/disk1/downloads";
    storage = "/mnt/storage";
    gameservers = "/mnt/ssd/gameservers";
  };
  common_env = {
    # TODO: Any way to acquire my user's IDs dynamically?
    PUID = "1000";
    PGID = "100";
    TZ = config.time.timeZone;
  };
in {
  virtualisation.oci-containers.containers = {
    plex = {
      image = "lscro.io/linuxserver/plex:latest"; # https://hub.docker.com/r/linuxserver/plex/
      volumes = [
        "${ appdata_path }/plex:/config"
        "${ storage_path }/media:/media"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        PLEX_CLAIM = "nope";
        VERSION = "docker";
      } ++ linuxserver_env;
      extraOptions = [
        "--network=host"
        "--device=/dev/dri:/dev/dri"
      ];
    };
    jellyfin = {
      image = "jellyfin/jellyfin";
      volumes = [
        "${ appdata_path }/jellyfin:/config"
        "${ storage_path }/media:/data"
        # "/dev/shm:/transcode" # ram transcode
      ];
      environment = {
        JELLYFIN_PublishedServerUrl = "watch.${ main_domain }";
      } ++ linuxserver_env;
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


    requestrr = {
      image = "lscr.io/linuxserver/requestrr:latest"; # https://hub.docker.com/r/linuxserver/requestrr
      volumes = [
        "${ appdata_path }/requestrr:/config"
      ];
      ports = [ "4545:4545" ];
      environment = linuxserver_env;
    };
    overseerr = {
      image = "lscr.io/linuxserver/overseerr:latest";
      volumes = [
        "${ appdata_path }/overseerr:/config"
      ];
      environment = linuxserver_env;
      # extraOptions = [
      #   "--network=public_access";
      # ];
      labels = {
        "traefik.enable" = true;
        "traefik.http.routers.overseerr.rule" = "Host(`request.${ main_domain }`)";
        "traefik.http.routers.overseerr.entrypoints" = "websecure";
      };
    };


    prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      volumes = [
        "${ appdata_path }/prowlarr:/config"
      ];
      ports = [ "9696:9696" ];
      environment = linuxserver_env;
    };
    radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      volumes = [
        "${ appdata_path }/radarr:/config"
        "${ storage_path }:/storage"
      ];
      ports = [ "7878:7878" ];
      environment = linuxserver_env;
    };
    sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      volumes = [
        "${ appdata_path }/sonarr:/config"
        "${ storage_path }:/storage"
      ];
      ports = [ "8989:8989" ];
      environment = linuxserver_env;
    };

    
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
        "${ appdata_path }/transmission:/config"
        "${ download_path }:/downloads"
        "${ download_path }:/watch" # TODO: Adjust this to a torrent blackhole
      ];
      environment = {
        # WHITELIST = "192.168.0.0/24";
        # TRANSMISSION_WEB_HOME = "";
      } ++ linuxserver_env;
      # This uses the gluetun network stack so that its behind VPN
      extraOptions = [ "--network=container:gluetun" ];
    };

    # transmission = {
    #   image = "haugene/transmission-openvpn:latest";
    #   volumes = [
    #     "/etc/localtime:/etc/localtime:ro"
    #     "${ download_path }:/data"
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