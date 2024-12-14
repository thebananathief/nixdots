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
  users = {
    groups.${mediaGroup} = { gid = 987; };
    groups.streamer = {};
    users.streamer = {
      group = "streamer";
      isSystemUser = true;
    };
  };

  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "streamer";
      group = mediaGroup;
    };
    jellyseerr = {
      enable = true;
      openFirewall = true;
      port = 8005;
    };
  };
  
  # Always prioritise Jellyfin IO
  systemd.services.jellyfin.serviceConfig.IOSchedulingPriority = 0;

  systemd.tmpfiles.rules = [
    "d '${config.services.jellyfin.dataDir}' 0700 streamer root - -"

    # Media Dirs
    "d '${cfg.storageDir}/media'          0775 streamer  media - -"
    "d '${cfg.storageDir}/media/books'    0775 streamer  media - -"
    "d '${cfg.storageDir}/media/family'   0775 streamer  media - -"
    "d '${cfg.storageDir}/media/movies'   0775 streamer  media - -"
    "d '${cfg.storageDir}/media/tv'       0775 streamer  media - -"
  ];

  services.caddy.virtualHosts = {
    # Jellyseerr
    "request.${ config.networking.fqdn }".extraConfig = ''
      reverse_proxy localhost:8005
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
    '';
    # Jellyfin
    "watch.${ config.networking.fqdn }".extraConfig = ''
      reverse_proxy localhost:8096
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
    '';
  };

  # For quicksync transcoding
  hardware.graphics = {
    enable = true;
    # enable32Bit = true;

    # Some of these are required for hardware transcoding
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };

  # Try this if systemd is waiting on shutdown
  # systemd.network.wait-online.enable = false;



  
  # virtualisation.oci-containers.containers = {
  #   # Media players
  #   # jellyfin = {
  #   #   image = "jellyfin/jellyfin";
  #   #   volumes = [
  #   #     "${cfg.dataDir}/jellyfin:/config"
  #   #     "${cfg.storageDir}/media:/data"
  #   #     # "/dev/shm:/transcode" # ram transcode
  #   #   ];
  #   #   ports = [
  #   #     "8096:8096"
  #   #     # "8920:8920" # HTTPS web interface
  #   #     "7359:7359/udp" # Optional - Allows clients to discover Jellyfin on the local network.
  #   #     "1900:1900/udp" # Optional - Service discovery used by DNLA and clients.
  #   #   ];
  #   #   environment =
  #   #     {
  #   #       # JELLYFIN_PublishedServerUrl = "watch.${ config.networking.fqdn }";
  #   #     }
  #   #     // cfg.common_env;
  #   #   extraOptions = [
  #   #     "--network=bridge"
  #   #     "--device=/dev/dri:/dev/dri"
  #   #   ];
  #   #   # user = "cameron:docker";
  #   # };
  #   # Media requesters
  #   # jellyseerr = {
  #   #   image = "fallenbagel/jellyseerr:latest";
  #   #   volumes = [
  #   #     "${cfg.dataDir}/jellyseerr:/app/config"
  #   #   ];
  #   #   ports = ["8005:5055"];
  #   #   environment =
  #   #     {
  #   #       LOG_LEVEL = "debug";
  #   #     }
  #   #     // cfg.common_env;
  #   #   extraOptions = [
  #   #     "--network=bridge"
  #   #   ];
  #   # };
  # };
}
