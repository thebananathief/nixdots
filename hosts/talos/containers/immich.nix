{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  immich_env = rec {
    IMMICH_VERSION = "release";
    mediaDir = "${cfg.storageDir}/media/family/pictures+videos";
    # IMMICH_MEDIA_LOCATION = "./immich";
    DB_USERNAME = "immich";
    DB_PASSWORD = "${secrets.postgres_password.path}";
    DB_DATABASE_NAME = "immich";
    DB_HOSTNAME = "immich-postgres";
    REDIS_HOSTNAME = "immich-redis";
  };
in {
  virtualisation.oci-containers.containers = {
    immich-server = { 
      image = "ghcr.io/immich-app/immich-server:${immich_env.IMMICH_VERSION}";
      cmd = [ "start.sh" "immich" ];
      environment = immich_env // cfg.common_env;
      volumes = [
        # "${immich_env.mediaDir}:/usr/src/app/upload"
        "${immich_env.mediaDir}:/usr/src/app/upload/library"
        "${immich_env.mediaDir}/thumbs:/usr/src/app/upload/thumbs"
        "${cfg.dataDir}/immich/upload:/usr/src/app/upload/upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
      ports = [ "8014:3001" ];
      dependsOn = [ "immich-postgres" "immich-redis" ];
      extraOptions = [
        "--network=immich"
      ];
      user = "cameron:docker";
    };
    immich-microservices = { 
      image = "ghcr.io/immich-app/immich-server:${immich_env.IMMICH_VERSION}";
      cmd = [ "start.sh" "microservices" ];
      environment = immich_env // cfg.common_env;
      volumes = [
        # "${immich_env.mediaDir}:/usr/src/app/upload"
        "${immich_env.mediaDir}:/usr/src/app/upload/library"
        "${immich_env.mediaDir}/thumbs:/usr/src/app/upload/thumbs"
        "${cfg.dataDir}/immich/upload:/usr/src/app/upload/upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
      dependsOn = [ "immich-postgres" "immich-redis" ];
      extraOptions = [
        "--network=immich"
        "--device=/dev/dri:/dev/dri"
      ];
      user = "1000:131";
    };
    immich-ml = { 
      image = "ghcr.io/immich-app/immich-machine-learning:${immich_env.IMMICH_VERSION}-openvino";
      environment = immich_env // cfg.common_env;
      volumes = [
        "${cfg.dataDir}/immich/modelcache:/cache"
        "/dev/bus/usb:/dev/bus/usb"
      ];
      extraOptions = [
        "--network=immich"
        "--device=/dev/dri:/dev/dri"
        "--device-cgroup-rule"
        "c 189:* rmw"
      ];
      user = "cameron:docker";
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
      extraOptions = [ "--network=immich" ];
    };
    immich-redis = {
      image = "redis:6.2-alpine@sha256:afb290a0a0d0b2bd7537b62ebff1eb84d045c757c1c31ca2ca48c79536c0de82";
      # ports = [ "6379:6379" ];
      extraOptions = [ "--network=immich" ];
    };
  };
}
