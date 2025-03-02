{ config, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    "postgres-ttrss.env" = {
      group = config.virtualisation.oci-containers.backend;
      mode = "0440";
    };
  };

  virtualisation.oci-containers.containers = {
    rss = {
      image = "wangqiru/ttrss:latest"; # https://hub.docker.com/r/wangqiru/ttrss
      volumes = [
        "${ cfg.dataDir }/ttrss/feed-icons:/var/www/feed-icons/:rw"
      ];
      ports = [ "8011:80" ];
      dependsOn = [ "postgres" ];
      environmentFiles = [
        secrets."postgres-ttrss.env".path # DB_PASS
      ];
      environment = {
        SELF_URL_PATH = "https://rss.${ config.networking.fqdn }/";
        DB_HOST = "postgres";
        DB_PORT = "5432";
        DB_USER = "postgres";
      } // cfg.common_env;
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
      environmentFiles = [
        secrets."postgres-ttrss.env".path # POSTGRES_PASSWORD
      ];
      extraOptions = [ "--network=ttrss" ];
    };
  };
  
  services.caddy.virtualHosts = {
    "rss.${ config.networking.fqdn }".extraConfig = ''
      tls internal
      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8011
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}
