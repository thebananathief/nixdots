{ config, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  # users.groups.dashy = {};
  # users.users.dashy = {
  #   uid = 980;
  #   group = "dashy";
  #   isSystemUser = true;
  # };

  virtualisation.oci-containers.containers = {
    dashy = {
      image = "lissy93/dashy:latest";
      volumes = [
        "${ cfg.dataDir }/dashy/config.yml:/app/public/conf.yml"
        "${ cfg.dataDir }/dashy/logos:/app/public/item-icons"
      ];
      ports = [ "8000:80" ];
      environment = {
        NODE_ENV = "production";
        UID = "1000";
        GID = "131";
      };
    };
  };
  
  services.caddy.virtualHosts = {
    "home.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8000
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}