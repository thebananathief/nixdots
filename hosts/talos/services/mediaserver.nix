{ config, pkgs, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  mediaserver_env = {
    PUID = "989"; # mediaserver
    PGID = "131"; # docker
    TZ = config.time.timeZone;
  };
in {
  users.groups.mediaserver = {};
  users.users.mediaserver = {
    # uid = 1001;
    group = "mediaserver";
    isSystemUser = true;
    description = "Mediaserver service account";
  };
  
  services = {
    plex = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "mediaserver";
      dataDir = "${ cfg.dataDir }/plex/Library/Application Support";
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "mediaserver";
    };
    jellyseerr = {
      enable = true;
      openFirewall = true;
      port = 8005;
    };
    audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
      user = "mediaserver";
      group = "mediaserver";
      port = 8009;
    };
    # sonarr = {
    #   enable = true;
    #   user = "mediaserver";
    #   group = "mediaserver";
    #   # dataDir = "/var/lib/sonarr/.config/NzbDrone";
    # };
    # radarr = {
    #   enable = true;
    #   user = "mediaserver";
    #   group = "mediaserver";
    #   # dataDir = "/var/lib/radarr/.config/Radarr";
    # };
    # prowlarr = {
    #   enable = true;
    # };
  };
  
  sops.secrets = {
    "mullvad.env" = {
      group = config.virtualisation.oci-containers.backend;
      mode = "0440";
    };
  };

  virtualisation.oci-containers.containers = {
    # Media players
    # plex = {
    #   image = "lscro.io/linuxserver/plex:latest"; # https://hub.docker.com/r/linuxserver/plex/
    #   volumes = [
    #     "${cfg.dataDir}/plex:/config"
    #     "${cfg.storageDir}/media:/media"
    #     "/etc/localtime:/etc/localtime:ro"
    #   ];
    #   environment =
    #     {
    #       PLEX_CLAIM = "nope";
    #       VERSION = "docker";
    #     }
    #     // cfg.common_env;
    #   extraOptions = [
    #     "--network=host"
    #     "--device=/dev/dri:/dev/dri"
    #   ];
    # };
    # jellyfin = {
    #   image = "jellyfin/jellyfin";
    #   volumes = [
    #     "${cfg.dataDir}/jellyfin:/config"
    #     "${cfg.storageDir}/media:/data"
    #     # "/dev/shm:/transcode" # ram transcode
    #   ];
    #   ports = [
    #     "8096:8096"
    #     # "8920:8920" # HTTPS web interface
    #     "7359:7359/udp" # Optional - Allows clients to discover Jellyfin on the local network.
    #     "1900:1900/udp" # Optional - Service discovery used by DNLA and clients.
    #   ];
    #   environment =
    #     {
    #       # JELLYFIN_PublishedServerUrl = "watch.${ config.networking.fqdn }";
    #     }
    #     // cfg.common_env;
    #   extraOptions = [
    #     "--network=bridge"
    #     "--device=/dev/dri:/dev/dri"
    #   ];
    #   # user = "cameron:docker";
    # };

    # Media requesters
    requestrr = {
      image = "lscr.io/linuxserver/requestrr:latest"; # https://hub.docker.com/r/linuxserver/requestrr
      volumes = [
        "${cfg.dataDir}/requestrr:/config"
      ];
      ports = ["8006:4545"];
      environment = mediaserver_env;
      extraOptions = [
        "--network=media"
      ];
    };
    # jellyseerr = {
    #   image = "fallenbagel/jellyseerr:latest";
    #   volumes = [
    #     "${cfg.dataDir}/jellyseerr:/app/config"
    #   ];
    #   ports = ["8005:5055"];
    #   environment =
    #     {
    #       LOG_LEVEL = "debug";
    #     }
    #     // cfg.common_env;
    #   extraOptions = [
    #     "--network=bridge"
    #   ];
    # };

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
      ports = ["8002:9696"];
      environment = mediaserver_env;
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
      ports = ["8003:7878"];
      environment = mediaserver_env;
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
      ports = ["8004:8989"];
      environment = mediaserver_env;
      extraOptions = [
        "--network=media"
      ];
    };

    # VPN and download client
    # https://github.com/qdm12/gluetun-wiki/
    gluetun = {
      image = "docker.io/qmcgaw/gluetun:v3";
      volumes = [
        "${cfg.dataDir}/gluetun:/gluetun"
      ];
      environmentFiles = [
        secrets."mullvad.env".path # WIREGUARD_PRIVATE_KEY WIREGUARD_ADDRESSES
      ];
      environment = {
        VPN_SERVICE_PROVIDER = "mullvad";
        VPN_TYPE = "wireguard";
        SERVER_COUNTRIES = "Switzerland";
        # OWNED_ONLY = "yes"; # Use if you want only servers owned by Mullvad
      };
      extraOptions = [
        "--network=media"
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
      image = "lscr.io/linuxserver/transmission:latest";
      volumes = [
        "${cfg.dataDir}/transmission:/config"
        "${cfg.downloadDir}:/downloads:rw"
        # "${cfg.downloadDir}/watch:/watch" # TODO: Adjust this to a torrent blackhole
      ];
      environment = mediaserver_env;
      # This uses the gluetun network stack so that its behind VPN
      extraOptions = ["--network=container:gluetun"];
      dependsOn = ["gluetun"];
    };
  };
  
  hardware.opengl = {
    enable = true;
    # driSupport = true;
    # driSupport32Bit = true;
    
    # Some of these are required for hardware transcoding
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };
}
