{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    postgres_password = {};
  };

  virtualisation.oci-containers.containers = {
    rss = {
      image = "wangqiru/ttrss:latest"; # https://hub.docker.com/r/wangqiru/ttrss
      volumes = [
        "${ cfg.dataDir }/ttrss/feed-icons:/var/www/feed-icons/:rw"
      ];
      ports = [ "8011:80" ];
      environment = {
        SELF_URL_PATH = "https://rss.${ config.networking.fqdn }/";
        DB_HOST = "postgres";
        DB_PORT = "5432";
        DB_USER = "postgres";
        DB_PASS = "${ secrets.postgres_password.path }";
      } // cfg.common_env;
      dependsOn = [ "postgres" ];
      extraOptions = [
        "--network=ttrss"
        # "--tty"
        "--interactive"
      ];
    };
    
    postgres = {
      image = "postgres:13-alpine";
      volumes = [
        "${ cfg.dataDir }/postgres/data/:/var/lib/postgresql/data" 
      ];
      ports = [ "5432:5432" ];
      environment = {
        POSTGRES_PASSWORD = "${secrets.postgres_password.path}";
      };
      extraOptions = [ "--network=ttrss" ];
    };
  };
}
