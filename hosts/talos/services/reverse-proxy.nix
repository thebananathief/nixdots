{ config, useremail, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  # Allow traffic in through HTTP and HTTPS ports,
  # caddy will handle it afterwards.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    email = useremail;
    # virtualHosts = {
    #   # Static fileserver and interactive filebrowser
    #   "files.${ config.networking.fqdn }".extraConfig = ''
    #     root * /mnt/storage/filebrowser
    #     file_server browse
    #   '';
    # };
  };
}
