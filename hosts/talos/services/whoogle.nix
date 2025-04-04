{ config, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  virtualisation.oci-containers.containers = {
    whoogle = {
      image = "benbusby/whoogle-search:latest";
      ports = ["8050:5000"];
      environment = {
        WHOOGLE_USER = "cameron";
        WHOOGLE_PASS = "dumbpassword";
      };
    };
  };

  services.caddy.virtualHosts = {
    "search.${ config.networking.fqdn }".extraConfig = ''
      tls internal
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
