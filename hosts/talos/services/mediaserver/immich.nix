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
}
