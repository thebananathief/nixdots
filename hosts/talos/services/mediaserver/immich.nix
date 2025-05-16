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

#  users = {
#    groups.pixmedia = {
#      members = [
#        "immich"
#      ];
#      gid = 986;
#    };
#  };

#   system.activationScripts.starbaseSetup = ''
#    chown -R immich:immich ${cfg.storageDir}/media/family/immich-media
#     chmod -R 770 ${cfg.storageDir}/media/family/immich-media
#     chown -R immich:immich ${cfg.storageDir}/media/family/uploads
#     chmod -R 770 ${cfg.storageDir}/media/family/uploads
#   '';

#  systemd.tmpfiles.rules = [
#    "d '${cfg.storageDir}/media/family/archive'  0775 immich    immich - -"
#    "d '${cfg.storageDir}/media/family/pictures+videos'  0775 immich    immich - -"
#    "d '${cfg.storageDir}/media/family/immich-media'  0775 immich    immich - -"
#    "d '${cfg.storageDir}/media/family/uploads'  0775 immich    immich - -"
#   ""
#  ];

  # runs as immich:immich by default
  # redis on unix sock and postgresql at immich@localhost:5432
  services.immich = {
    enable = true;
#     host = "localhost";
    # port = 2283;
    # openFirewall = true;
    mediaLocation = "${cfg.storageDir}/media/family/immich-media";
    # secretsFile = secrets."postgres-immich.env".path;
#     environment = {
      # IMMICH_LOG_LEVEL = "verbose";
#       UPLOAD_LOCATION = "${cfg.storageDir}/media/family/uploads";
#     };
    accelerationDevices = [
      "/dev/dri/renderD128"
    ];
#     settings.server.externalDomain = "https://photos.${config.networking.publicDomain}";
  };

  services.caddy.virtualHosts = {
    # Immich
    "photos.${ config.networking.publicDomain }".extraConfig = ''
      reverse_proxy localhost:2283
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
    '';
    "photos.${ config.networking.fqdn }".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:2283
    '';
  };
}
