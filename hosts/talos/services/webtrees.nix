{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    email_address = {};
    "mysql-webtrees.env" = {
      group = config.virtualisation.oci-containers.backend;
      mode = "0440";
    };
  };

  virtualisation.oci-containers.containers = {
    webtrees = {
      image = "dtjs48jkt/webtrees:latest"; # https://hub.docker.com/r/dtjs48jkt/webtrees/
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "${ cfg.dataDir }/webtrees/data:/var/www/html/data"
        "${ cfg.dataDir }/webtrees/modules:/var/www/html/modules_v4"
      ];
      ports = [ "8013:8013" ];
      environmentFiles = [
        secrets."mysql-webtrees.env".path # DB_PASSWORD, WT_ADMINMAIL, WT_ADMINPW
      ];
      environment = {
        DB_USER = "root";
        DB_HOST = "mysql";
        DB_PORT = "3306";
        DB_NAME = "webtrees";
        WT_ADMIN = "thebananathief";
        GROUP_ID = "${ cfg.common_env.PGID }";
        PORT = "8013";
        DISABLE_SSL = "TRUE";
        # PrettyURLs require filling out Base URL
        # This container is weird and sets these IF they're in here, so go check the actual configs to ensure values
        PRETTYURLS = "FALSE";
        BASE_URL = "";
        # PRETTYURLS = "TRUE";
        # BASE_URL = "https://tree.${ config.networking.fqdn }";
      };
      dependsOn = [ "mysql" ];
      extraOptions = [ "--network=webtrees" ];
    };

    mysql = {
      image = "mysql";
      volumes = [
        "${ cfg.dataDir }/mysql:/var/lib/mysql"
      ];
      ports = [ "3306:3306" ];
      environmentFiles = [
        secrets."mysql-webtrees.env".path # MYSQL_ROOT_PASSWORD
      ];
      environment = {
        MYSQL_DATABASE = "webtrees";
        MYSQL_ROOT_HOST = "%"; # should allow connections into the db as root from any interface
      };
      extraOptions = [ "--network=webtrees" ];
    };
  };
  
  services.caddy.virtualHosts = {
    "tree.${ config.networking.fqdn }".extraConfig = ''
      reverse_proxy localhost:8013
    '';
  };
}
