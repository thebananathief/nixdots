{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    mysql_password = {
      group = config.virtualisation.oci-containers.backend;
      mode = "0440";
    };
    castopod_mysql_password = {};
    castopod_salt = {};
  };
  
  virtualisation.oci-containers.containers = {
    # Ensure the castopod user is within this db
  
    castopod = {
      image = "castopod/castopod:latest";
      volumes = [
        "${ cfg.dataDir }/castopod/app:/var/www/castopod/public/media"
      ];
      ports = [ "8015:8000" ];
      environment = {
        MYSQL_DATABASE = "castopod";
        MYSQL_USER = "castopod";
        MYSQL_PASSWORD = "${ secrets.castopod_mysql_password.path }";
        CP_BASEURL = "https://castopod.${ config.networking.fqdn }";
        CP_ANALYTICS_SALT = "${ secrets.castopod_salt.path }";
        CP_CACHE_HANDLER = "redis";
        CP_REDIS_HOST = "redis";
      };
      extraOptions = [
        "--network=castopod-app,castopod-db"
      ];
    };
    
    castopod-mariadb = {
      image = "mariadb:10.5";
      volumes = [
        "${ cfg.dataDir }/castopod/mariadb:/var/lib/mysql"
      ];
      environment = {
        MYSQL_DATABASE = "castopod";
        MYSQL_USER = "castopod";
        MYSQL_PASSWORD = "${ secrets.castopod_mysql_password.path }";
        MYSQL_ROOT_PASSWORD = "${ secrets.mysql_password.path }";
      };
      extraOptions = [
        "--network=castopod-db"
      ];
    };
    
    castopod-redis = {
      image = "redis:7.0-alpine";
      volumes = [
        "${ cfg.dataDir }/castopod/cache:/data"
      ];
      extraOptions = [
        "--network=castopod-app"
      ];
    };
  };
}
