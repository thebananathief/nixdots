{config, ...}: let

in {
    services.hedgedoc = {
        enable = true;
        settings = {
            # domain = "hedgedoc.${config.networking.fqdn}";
            port = 8019;
        };
    };
#   virtualisation.oci-containers.containers = {
#     hedgedoc = {
#       image = "lscr.io/linuxserver/hedgedoc:latest";
#       volumes = [
#         "${ cfg.dataDir }/hedgedoc:/config"
#       ];
#       ports = [ "8019:3000" ];
#       environment = {
#         # DB_HOST = "mysql";
#         # DB_PORT = 3306;
#         # DB_USER = "root";
#         # DB_PASS = "${ mysql_password }";
#         # DB_NAME = "hedgedoc";
#         CMD_CONFIG_FILE = ''
#         {
#           "dialect": "sqlite",
#           "storage": "/config/hedgedoc.sqlite"
#         }
#         '';
#         NODE_ENV = "production";
#         CMD_URL_ADDPORT = "true";
#         # CMD_DOMAIN = "notes.${ config.networking.fqdn }";
#         # CMD_PROTOCOL_USESSL = "false"; #optional - use if on a reverse proxy
#         # CMD_PORT = 3000; #optional
#         # CMD_ALLOW_ORIGIN = "['localhost']"; #optional
#       } // cfg.common_env;
#     };
#   };

  services.caddy.virtualHosts = {
    "hedgedoc.${config.networking.fqdn}".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:8019
    '';
  };
}