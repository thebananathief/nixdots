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
      reverse_proxy localhost:8050
    '';
  };
}
