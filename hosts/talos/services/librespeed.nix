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
    "speedtest.${ config.localFqdn }".extraConfig = ''
      reverse_proxy localhost:8016
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
    '';
    # "speedtest.${ config.networking.fqdn }".extraConfig = ''
    #   reverse_proxy localhost:8016
    #   tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
    # '';
  };
}
