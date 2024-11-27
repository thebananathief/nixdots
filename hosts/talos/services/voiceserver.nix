{ config, ... }:
let
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    "murmur.env" = {
      group = "murmur";
      mode = "0400";
    };
  };
    
  services = {
    # matrix-conduit = {
    #   enable = true;
    #   settings.global = {
    #     port = 6167;
    #     max_request_size = 20000000;
    #     allow_registration = true;
    #     allow_federation = true;
    #     allow_check_for_updates = true;
    #     allow_encryption = true;
    #     server_name = "chat.${config.networking.fqdn}";
    #     trusted_servers = [
    #       "matrix.org"
    #     ];
    #     address = "::1"; #loopback ipv6
    #   };
    # };;
    
    murmur = {
      enable = true;
      port = 64738; # default
      clientCertRequired = false;
      welcometext = "Welcome to the Shire!";
      # hostName = "chat.${config.networking.fqdn}";
      # registerHostname = "chat.${config.networking.fqdn}";
      registerName = "The Shire";
      environmentFile = secrets."murmur.env".path;
      registerPassword = "$MURMUR_REGISTER_PASSWORD";
      openFirewall = true;
    };
    
    # Mumble = TCP + UDP | Caddy = only does TCP (HTTPS)
    # caddy.virtualHosts = {
    #   "voice.${ config.networking.fqdn }".extraConfig = ''
    #     reverse_proxy localhost:64738
    #   '';
    # };
  };
}
