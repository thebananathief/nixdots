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
    virtualHosts = {
      # Jellyseerr
      "request.${ config.networking.fqdn }".extraConfig = ''
        reverse_proxy localhost:8005
      '';
      # Jellyfin
      "watch.${ config.networking.fqdn }".extraConfig = ''
        reverse_proxy localhost:8096
      '';
      # Webtrees
      # "tree.${ config.networking.fqdn }".extraConfig = ''
      #   reverse_proxy localhost:8013
      # '';
      # Librespeed
      # "speedtest.${ config.networking.fqdn }".extraConfig = ''
      #   reverse_proxy localhost:8016
      # '';
      # Static fileserver and interactive filebrowser
      "files.${ config.networking.fqdn }".extraConfig = ''
        root * /mnt/storage/filebrowser
        file_server browse
      '';
      # TTRSS
      "rss.${ config.networking.fqdn }".extraConfig = ''
        reverse_proxy localhost:8011
      '';
      # Audiobookshelf
      "books.${ config.networking.fqdn }".extraConfig = ''
        reverse_proxy localhost:8009
      '';
      # Mumble?
      # matrix-conduit
      # "chat.${ config.networking.fqdn }".extraConfig = ''
      #   reverse_proxy localhost:6167
      # '';
    };
  };
}
