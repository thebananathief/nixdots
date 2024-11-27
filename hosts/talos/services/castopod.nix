{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    webtrees_mysql_password = {
      group = config.virtualisation.oci-containers.backend;
      mode = "0440";
    };
    castopod_mysql_password = {};
    castopod_salt = {};
    redis_password = {};
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
        CP_DATABASE_HOSTNAME = "castopod-mariadb";
        CP_REDIS_HOST = "castopod-redis";
        CP_REDIS_PASSWORD = "${ secrets.redis_password.path }";
      };
      extraOptions = [
        "--network=castopod"
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
        MYSQL_ROOT_PASSWORD = "${ secrets.webtrees_mysql_password.path }";
      };
      extraOptions = [
        "--network=castopod"
      ];
    };

    castopod-redis = {
      image = "redis:7.0-alpine";
      volumes = [
        "${ cfg.dataDir }/castopod/cache:/data"
      ];
      cmd = [ "--requirepass ${ secrets.redis_password.path }" ];
      extraOptions = [
        "--network=castopod"
      ];
    };
  };
  
  services.caddy.virtualHosts = {
    # TIP: use /cp-admin to login to the admin panel
    "castopod.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8015
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}
