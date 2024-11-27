{ config, ... }:
let
  cfg = config.myOptions.containers;
in {
  virtualisation.oci-containers.containers = {
    librespeed = {
      image = "lscr.io/linuxserver/librespeed:latest";
      volumes = [
        "${ cfg.dataDir }/librespeed:/config"
      ];
      environment = {
        PASSWORD = "PASSWORD";
      } // cfg.common_env;
      ports = [ "8016:80" ];
    };
  };
  
  services.caddy.virtualHosts = {
    "speedtest.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8016
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}
