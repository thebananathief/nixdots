{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  immich_env = {
    IMMICH_VERSION = "what";
    UPLOAD_LOCATION = "${cfg.storageDir}/media/family/pictures+videos";
    DB_USERNAME = "immich";
    DB_PASSWORD = "${secrets.postgres_password.path}";
    DB_DATABASE_NAME = "immich";
    DB_HOSTNAME = "immich-postgres";
    REDIS_HOSTNAME = "immich-redis";
  };
in {
  virtualisation.oci-containers.containers = {
    immich-server = { 
      image = "ghcr.io/immich-app/immich-server:${immich_env.IMMICH_VERSION}-release";
      cmd = [ "start.sh" "immich" ];
      environment = immich_env // cfg.common_env;
      volumes = [
        "${immich_env.UPLOAD_LOCATION}:/usr/src/app/upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
      ports = [ "8014:3001" ];
      dependsOn = [ "immich-postgres" "immich-redis" ];
      extraOptions = [
        "--network=database_immich"
      ];
    };
    immich-microservices = { 
      image = "ghcr.io/immich-app/immich-server:${immich_env.IMMICH_VERSION}-release";
      cmd = [ "start.sh" "microservices" ];
      environment = immich_env // cfg.common_env;
      volumes = [
        "${immich_env.UPLOAD_LOCATION}:/usr/src/app/upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
      dependsOn = [ "immich-postgres" "immich-redis" ];
      extraOptions = [
        "--network=database_immich"
        "--device=/dev/dri:/dev/dri"
      ];
    };
    immich-ml = { 
      image = "ghcr.io/immich-app/immich-machine-learning:${immich_env.IMMICH_VERSION}-release-openvino";
      environment = immich_env // cfg.common_env;
      volumes = [
        "${cfg.dataDir}/immich/modelcache:/cache"
        "/dev/bus/usb:/dev/bus/usb"
      ];
      extraOptions = [
        "--network=database_immich"
        "--device=/dev/dri:/dev/dri"
        "--device-cgroup-rule='c 189:* rmw'"
      ];
    };
    immich-postgres = {
      image = "tensorchord/pgvecto-rs:pg14-v0.1.11@sha256:0335a1a22f8c5dd1b697f14f079934f5152eaaa216c09b61e293be285491f8ee";
      volumes = [
        "${ cfg.dataDir }/immich/data/:/var/lib/postgresql/data" 
      ];
      # ports = [ "5433:5432" ]; # running a postgres13 on 5432
      environment = {
        POSTGRES_USER = "${immich_env.DB_USERNAME}";
        POSTGRES_PASSWORD = "${immich_env.DB_PASSWORD}";
        POSTGRES_DB = "${immich_env.DB_DATABASE_NAME}";
      };
      extraOptions = [ "--network=database_immich" ];
    };
    immich-redis = {
      image = "redis:6.2-alpine@sha256:afb290a0a0d0b2bd7537b62ebff1eb84d045c757c1c31ca2ca48c79536c0de82";
      # ports = [ "6379:6379" ];
      extraOptions = [ "--network=database_immich" ];
    };
  };
}
