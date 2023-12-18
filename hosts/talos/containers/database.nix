{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    # influx_db_token = {};
    # influx_db_pass = {};
    mysql_password = {
      group = config.virtualisation.oci-containers.backend;
      mode = "0440";
    };
    postgres_password = {};
  };
  
  virtualisation.oci-containers.containers = {
    # adminer = {
    #   image = "adminer"; # https://hub.docker.com/_/adminer
    #   ports = [ "8085:8080" ];
    #   extraOptions = [ "--network=database_only" ];
    # };
    postgres = {
      image = "postgres:13-alpine";
      volumes = [
        "${ cfg.dataDir }/postgres/data/:/var/lib/postgresql/data" # TODO: Migrate to /mnt/storage ? performance considerations?
      ];
      ports = [ "5432:5432" ];
      environment = {
        POSTGRES_PASSWORD = "${secrets.postgres_password.path}";
      };
      extraOptions = [ "--network=database_postgres" ];
    };
    mysql = {
      image = "mysql";
      volumes = [
        "${ cfg.dataDir }/mysql:/var/lib/mysql" # TODO: Migrate to /mnt/storage ? performance considerations?
      ];
      ports = [ "3306:3306" ];
      environment = {
        MYSQL_ROOT_PASSWORD = "${secrets.mysql_password.path}";
      };
      extraOptions = [ "--network=database_mysql" ];
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
