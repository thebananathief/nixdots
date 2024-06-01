{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    # influx_db_token = {};
    # influx_db_pass = {};
  };

  # TODO: Migrate to /mnt/storage ? performance considerations?
  virtualisation.oci-containers.containers = {
    adminer = {
      image = "adminer"; # https://hub.docker.com/_/adminer
      ports = [ "8085:8080" ];
      extraOptions = [
        # "--network=immich"
        # "--network=ttrss"
        "--network=webtrees"
        # "--network=castopod"
      ];
    };

    # TODO: Need to install telegraf to use this or use the prometheus suite
    # influxdb = {
    #   image = "influxdb:alpine"; # https://hub.docker.com/_/influxdb/
    #   volumes = [
    #     "${ cfg.dataDir }/influxdb/config:/etc/influxdb2"
    #     "${ cfg.dataDir }/influxdb/data:/var/lib/influxdb2"
    #   ];
    #   ports = [ "8086:8086" ];
    #   environment = {
    #     DOCKER_INFLUXDB_INIT_MODE = "setup";
    #     DOCKER_INFLUXDB_INIT_USERNAME = "root";
    #     DOCKER_INFLUXDB_INIT_PASSWORD = "${ influx_db_pass }";
    #     DOCKER_INFLUXDB_INIT_ORG = "default";
    #     DOCKER_INFLUXDB_INIT_BUCKET = "telegraf";
    #     DOCKER_INFLUXDB_INIT_ADMIN_TOKEN = "${ influx_db_token }"
    #   };
    #   extraOptions = [
    #     # "--network=database_only"
    #     "--health-cmd='[CMD, curl, -f, http://localhost:8086/health]'"
    #     "--health-interval=5s"
    #     "--health-retries=20"
    #     "--health-start-period=0s"
    #     "--health-timeout=10s"
    #   ];
    # };
  };
}
