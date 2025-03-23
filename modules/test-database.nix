{ config, pkgs, ... }:
let
  cfg = config.mediaServer;
in {
  # Create the Docker network and volumes
  systemd.services.test-mysql-network = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" "docker.socket" ];
    script = ''
      # Create network if it doesn't exist
      ${pkgs.docker}/bin/docker network inspect testmysql >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create testmysql
    '';
  };

  virtualisation.oci-containers.containers = {
    mysql1 = {
      image = "container-registry.oracle.com/mysql/enterprise-server:8.0";
      volumes = [ "${ cfg.dataDir }/testmysql/mysql1:/var/lib/mysql" ];
      environment = {
        # MYSQL_DATABASE = "";
        # MYSQL_USER = "";
        # MYSQL_PASSWORD = "";
        MYSQL_ROOT_PASSWORD = "test123";
      };
      extraOptions = [
        "--network=testmysql"
      ];
      ports = [
        "3306:3306"
      ];
    };
    mysql2 = {
      image = "container-registry.oracle.com/mysql/enterprise-server:8.0";
      volumes = [ "${ cfg.dataDir }/testmysql/mysql2:/var/lib/mysql" ];
      environment = {
        MYSQL_ROOT_PASSWORD = "test123";
      };
      extraOptions = [
        "--network=testmysql"
      ];
      ports = [
        "3307:3306"
      ];
    };
    mysql3 = {
      image = "container-registry.oracle.com/mysql/enterprise-server:8.0";
      volumes = [ "${ cfg.dataDir }/testmysql/mysql3:/var/lib/mysql" ];
      environment = {
        MYSQL_ROOT_PASSWORD = "test123";
      };
      extraOptions = [
        "--network=testmysql"
      ];
      ports = [
        "3308:3306"
      ];
    };
    mysql4 = {
      image = "container-registry.oracle.com/mysql/enterprise-server:8.0";
      volumes = [ "${ cfg.dataDir }/testmysql/mysql4:/var/lib/mysql" ];
      environment = {
        MYSQL_ROOT_PASSWORD = "test123";
      };
      extraOptions = [
        "--network=testmysql"
      ];
      ports = [
        "3309:3306"
      ];
    };
    mysqlrouter = {
      image = "container-registry.oracle.com/mysql/enterprise-router:8.0";
      # volumes = [ "${ cfg.dataDir }/testmysql/router:/var/lib/mysql" ];
      environment = {
        MYSQL_HOST = "mysql1";
        MYSQL_PORT = "3306";
        MYSQL_USER = "mysqlrouter";
        MYSQL_PASSWORD = "test123";
        # MYSQL_INNODB_CLUSTER_MEMBERS = "3";
      };
      extraOptions = [
        "--network=testmysql"
      ];
      ports = [
        "6446:6446" # R/W connection port (clients will be sent to a PRIMARY)
        "6447:6447" # R/O connection port (clients will be sent to a SECONDARY)
        "8443:8443" # https://dev.mysql.com/doc/mysql-router/en/mysql-router-rest-api-reference.html
      ];
    };
  };

  # services.mysql = {
  #   enable = true;
  #   package = pkgs.mariadb;
  #   ensureUsers = [
  #     {
  #       name = "cameron";
  #       ensurePermissions = {
  #         "*.*" = "ALL PRIVILEGES";
  #       };
  #     }
  #   ];
    # settings = {
    #   mysqld = {
    #     key_buffer_size = "6G";
    #     table_cache = 1600;
    #     log-error = "/var/log/mysql_err.log";
    #     plugin-load-add = [ "server_audit" "ed25519=auth_ed25519" ];
    #   };
    #   mysqldump = {
    #     quick = true;
    #     max_allowed_packet = "16M";
    #   };
    # };
  # };
}
