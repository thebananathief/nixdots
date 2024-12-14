{ config, pkgs, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  mediaserver_env = {
    PUID = "989"; # mediaserver
    PGID = "131"; # docker
    TZ = config.time.timeZone;
  };
  downloadDir = "/mnt/disk3/downloads";
in {
  services = {
    audiobookshelf = {
      enable = true;
      host = "0.0.0.0"; # Required to allow external clients to connect to this webserver
      user = "mediaserver";
      group = "mediaserver";
      port = 8009;
    };
  };
  
  services.caddy.virtualHosts = {
    # Audiobookshelf
    "books.${ config.networking.fqdn }".extraConfig = ''
      reverse_proxy localhost:8009
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
    '';
  };
}