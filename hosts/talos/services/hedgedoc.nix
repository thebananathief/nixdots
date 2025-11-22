{config, ...}: let
  cfg = config.mediaServer;
in {
  virtualisation.oci-containers.containers = {
    hedgedoc = {
      image = "lscr.io/linuxserver/hedgedoc:latest";
      volumes = [
        "${ cfg.dataDir }/hedgedoc:/config"
      ];
      ports = [ "8016:3000" ];
      environment = {
        # DB_HOST = "mysql";
        # DB_PORT = 3306;
        # DB_USER = "root";
        # DB_PASS = "${ mysql_password }";
        # DB_NAME = "hedgedoc";
        CMD_CONFIG_FILE = ''
        {
          "dialect": "sqlite",
          "storage": "/config/hedgedoc.sqlite"
        }
        '';
        NODE_ENV = "production";
        CMD_URL_ADDPORT = "true";
        # CMD_DOMAIN = "notes.${ config.networking.fqdn }";
        # CMD_PROTOCOL_USESSL = "false"; #optional - use if on a reverse proxy
        # CMD_PORT = 3000; #optional
        # CMD_ALLOW_ORIGIN = "['localhost']"; #optional
      } // cfg.common_env;
    };
  };
}