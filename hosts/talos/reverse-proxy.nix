{ config, builtins, lib, useremail, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  main_domain = "$__file{${secrets.main_domain.path}}";
in {
  # Allow traffic in through HTTP and HTTPS ports,
  # caddy will handle it afterwards.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    email = useremail;
    virtualHosts = {
      # Jellyseerr
      "request.${ main_domain }".extraConfig = ''
        reverse_proxy localhost:8005
      '';
      # Jellyfin
      "watch.${ main_domain }".extraConfig = ''
        reverse_proxy localhost:8096
      '';
      # Webtrees
      "tree.${ main_domain }".extraConfig = ''
        reverse_proxy localhost:8013
      '';
      # Filebrowser
      "files.${ main_domain }".extraConfig = ''
        reverse_proxy localhost:8009
      '';
    };
  };
}