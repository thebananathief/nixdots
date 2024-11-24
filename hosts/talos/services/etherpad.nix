{ config, ... }:
let
  cfg = config.myOptions.containers;
  # inherit (config.sops) secrets;
in {
  # sops.secrets = {
  #   "postgres-etherpad.env" = {
  #     group = config.virtualisation.oci-containers.backend;
  #     mode = "0440";
  #   };
  # };

  virtualisation.oci-containers.containers = {
    etherpad = {
      image = "etherpad/etherpad:latest";
      user = "0:0";
      volumes = [
        "${ cfg.dataDir }/etherpad/plugins:/opt/etherpad-lite/src/plugin_packages"
        "${ cfg.dataDir }/etherpad/var:/opt/etherpad-lite/var"
      ];
      ports = [
        "9001:9001"
      ];
      # environmentFiles = [
      #   secrets."postgres-etherpad.env".path # DB_PASS
      # ];
      environment = {
        NODE_ENV = "production";
        ADMIN_PASSWORD = "admin";
        DB_CHARSET = "utf8mb4";
        DB_HOST = "etherpad-postgres";
        DB_NAME = "etherpad";
        DB_PASS = "admin";
        DB_PORT = "5432";
        DB_TYPE = "postgres";
        DB_USER = "admin";
        # For now, the env var DEFAULT_PAD_TEXT cannot be unset or empty; it seems to be mandatory in the latest version of etherpad
        DEFAULT_PAD_TEXT = "";
        DISABLE_IP_LOGGING = "false";
        SOFFICE = "null";
        TRUST_PROXY = "true";
      } // cfg.common_env;
      extraOptions = [
        "--network=etherpad"
        # "--tty"
        "--interactive"
      ];
      dependsOn = [ "etherpad-postgres" ];
    };
    
    etherpad-postgres = {
      image = "postgres:15-alpine";
      volumes = [
        "${ cfg.dataDir }/etherpad-postgres/data/:/var/lib/postgresql/data" 
      ];
      # ports = [ "5432:5432" ];
      # environmentFiles = [
      #   secrets."postgres-etherpad.env".path # POSTGRES_PASSWORD
      # ];
      environment = {
        POSTGRES_DB = "etherpad";
        POSTGRES_PASSWORD = "admin";
        POSTGRES_PORT = "5432";
        POSTGRES_USER = "admin";
        PGDATA = "/var/lib/postgresql/data/pgdata";
      };
      extraOptions = [ "--network=etherpad" ];
    };
  };
  
  services.caddy.virtualHosts = {
    # Etherpad
    "notes.${ config.networking.fqdn }".extraConfig = ''
      reverse_proxy localhost:9001
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
    '';
  };
}
