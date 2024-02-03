{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {

  virtualisation.oci-containers.containers = {
    immich = { # unofficial monolith container
      image = "ghcr.io/imagegenius/immich:latest";
      environment = {
        DB_HOSTNAME = "postgres14";
        DB_USERNAME = "immich";
        DB_PASSWORD = "${secrets.postgres_password.path}";
        DB_DATABASE_NAME = "immich";
        REDIS_HOSTNAME = "redis";
        DB_PORT = "5433";
        REDIS_PORT = "6379";
        # REDIS_PASSWORD = ;
        # MACHINE_LEARNING_GPU_ACCELERATION = "openvino";
        # MACHINE_LEARNING_WORKERS = "1";
        # MACHINE_LEARNING_WORKER_TIMEOUT = "120";
      } // cfg.common_env;
      volumes = [
        "${cfg.dataDir}/immich/config:/config"
        "${cfg.storageDir}/storage/media/pictures+videos:/photos"
        # "/dev/bus/usb:/dev/bus/usb"
      ];
      ports = [ "8014:8080" ];
      extraOptions = [
        "--network=database_immich"
        # "--device-cgroup-rule='c 189:* rmw'"
        "--device=/dev/dri:/dev/dri"
      ];
    };
    postgres14 = {
      image = "tensorchord/pgvecto-rs:pg14-v0.1.11";
      volumes = [
        "${ cfg.dataDir }/immich/data/:/var/lib/postgresql/data" 
      ];
      ports = [ "5433:5432" ]; # running a postgres13 on 5432
      environment = {
        POSTGRES_USER = "${config.virtualisation.oci-containers.containers.immich.environment.DB_USERNAME}";
        POSTGRES_PASSWORD = "${secrets.postgres_password.path}";
        POSTGRES_DB = "${config.virtualisation.oci-containers.containers.immich.environment.DB_DATABASE_NAME}";
      };
      extraOptions = [ "--network=database_immich" ];
    };
    redis = {
      image = "redis";
      ports = [ "6379:6379" ];
      extraOptions = [ "--network=database_immich" ];
    };
  };
}
