{ 
  appdata_path,
  storage_path,
  download_path,
  linuxserver_env,
  ...
}: {
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

  
  transmission = {
    image = "haugene/transmission-openvpn:latest";
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${ download_path }:/data"
    ];
    ports = [ "9092:9091" ];
    environment = {
      PUID = "${ main_uid }";
      PGID = "${ main_gid }";
      OPENVPN_PROVIDER = "NORDVPN";
      NORDVPN_COUNTRY = "US";
      NORDVPN_CATEGORY = "legacy_p2p";
      OPENVPN_USERNAME = "${ nordvpn_user }";
      OPENVPN_PASSWORD = "${ nordvpn_pass }";
      OPENVPN_OPTS = "--inactive 3600 --ping 10 --ping-exit 60";
      LOCAL_NETWORK = "192.168.0.0/24";
      # TRANSMISSION_WEB_UI = "combustion";
    };
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun"
      "--dns=8.8.8.8"
      "--dns=8.8.4.4"
    ];
  };
}