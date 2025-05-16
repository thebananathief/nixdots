{ config, pkgs, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  services = {
    audiobookshelf = {
      enable = true;
      host = "0.0.0.0"; # Required to allow external clients to connect to this webserver
      user = "streamer";
      group = "${cfg.mediaGroup}";
      port = 8009;
    };
  };
  
  services.caddy.virtualHosts = {
    # Audiobookshelf
    "books.${ config.networking.publicDomain }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
      reverse_proxy localhost:8009
    '';
    "books.${ config.networking.fqdn }".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:8009
    '';
  };
}