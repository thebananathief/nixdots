{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  main_domain = secrets.main_domain.path;
in {
  # Allow traffic in through HTTP and HTTPS ports,
  # caddy will handle it afterwards.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    virtualHosts = {
      "request.${ main_domain }".extraConfig = ''
        reverse_proxy localhost:8005
      '';
      "watch.${ main_domain }".extraConfig = ''
        reverse_proxy localhost:8096
      '';
      "tree.${ main_domain }".extraConfig = ''
        reverse_proxy localhost:8013
      '';
      "files.${ main_domain }".extraConfig = ''
        reverse_proxy localhost:8009
      '';
    };
  };
}