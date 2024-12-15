{ config, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  virtualisation.oci-containers.containers = {
    starbase80 = {
      image = "jordanroher/starbase-80:latest";
      volumes = [
        "${ cfg.dataDir }/starbase/config.json:/app/src/config/config.json"
        "${ cfg.dataDir }/starbase/public/favicon.ico:/app/public/favicon.ico"
        "${ cfg.dataDir }/starbase/public/logo.png:/app/public/logo.png"
        "${ cfg.dataDir }/starbase/public/icons:/app/public/icons"
      ];
      ports = [ "8002:4173" ];
      environment = {
        TITLE = "Talos Home";
        LOGO = "/starbase80.jpg";
      };
    };
  };
  
  services.caddy.virtualHosts = {
    "base.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8002
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}