{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    email_address = {};
    "postgres-webtrees.env" = {
      group = config.virtualisation.oci-containers.backend;
      mode = "0440";
    };
  };

  virtualisation.oci-containers.containers = {
    webtrees = {
      image = "nathanvaughn/webtrees"; # https://hub.docker.com/r/nathanvaughn/webtrees
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "${ cfg.dataDir }/webtrees/data:/var/www/webtrees/data"
        "${ cfg.dataDir }/webtrees/modules_v4:/var/www/webtrees/modules_v4"
      ];
      ports = [ 
        "8013:80" 
        # "8023:443"
      ];
      environmentFiles = [
        secrets."postgres-webtrees.env".path 
      ];
      environment = {
        DB_TYPE = "pgsql";
        DB_PORT = "5432";
        DB_HOST = "webtrees-postgres";
        # DB_NAME = "webtrees";
        # DB_USER = "webtrees";
        # WT_NAME= "Cameron Salomone";
        # WT_USER= "thebananathief";
        PGID = "${ cfg.common_env.PGID }";
        # PrettyURLs require filling out Base URL
        PRETTYURLS = "TRUE";
        BASE_URL = "http://talos:8013";
        # BASE_URL = "https://tree.${ config.networking.fqdn }";
        # HTTPS = "True";
      };
      dependsOn = [ "webtrees-postgres" ];
      extraOptions = [ "--network=webtrees" ];
    };

    webtrees-postgres = {
      image = "postgres:alpine";
      volumes = [
        "${ cfg.dataDir }/webtrees-postgres:/var/lib/postgres/data"
      ];
      ports = [ "5432:5432" ];
      environmentFiles = [
        secrets."postgres-webtrees.env".path 
      ];
      environment = {
        PGDATA = "/var/lib/postgresql/data/pgdata";
      };
      extraOptions = [ "--network=webtrees" ];
    };
  };
  
  # services.caddy.virtualHosts = {
  #   "tree.${ config.networking.fqdn }".extraConfig = ''
  #     reverse_proxy localhost:8013
  #   '';
  # };
}
