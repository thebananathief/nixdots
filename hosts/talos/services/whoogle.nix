{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  virtualisation.oci-containers.containers = {
    whoogle = {
      image = "benbusby/whoogle-search:latest";
      ports = ["8050:5000"];
      environment = {
        WHOOGLE_USER = "cameron";
        WHOOGLE_PASS = "dumbpassword";
      } // cfg.common_env;
    };
  };

  services.caddy.virtualHosts = {
    "search.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8050
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}
