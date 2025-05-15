{ config, ... }:
let
  cfg = config.mediaServer;
  # inherit (config.sops) secrets;
in {
  # sops.secrets = {
  #   "postgres-immich.env" = {
  #     group = config.virtualisation.oci-containers.backend;
  #     mode = "0440";
  #   };
  # };

  # runs as immich:immich by default
  # redis on unix sock and postgresql at immich@localhost:5432
  services.immich = {
    enable = true;
    host = "localhost";
    # port = 2283;
    # openFirewall = true;
    mediaLocation = "${cfg.storageDir}/media/family/pictures+videos";
    # secretsFile = secrets."postgres-immich.env".path;
    environment = {
      # IMMICH_LOG_LEVEL = "verbose";
      UPLOAD_LOCATION = "${cfg.storageDir}/media/family/uploads";
    };
    accelerationDevices = [
      "/dev/dri/renderD128"
    ];
    settings.server.externalDomain = "https://photos.${config.networking.publicDomain}";
  };

  services.caddy.virtualHosts = {
    # Immich
    "photos.${ config.networking.publicDomain }".extraConfig = ''
      reverse_proxy localhost:2283
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
    '';
    "photos.${ config.networking.fqdn }".extraConfig = ''
      tls internal
      @authorized remote_ip 192.168.0.0/24, fc00::/7
      handle @authorized {
        reverse_proxy localhost:2283
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}
