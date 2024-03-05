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

    # mumble = {
    #   image = "mumblevoip/mumble-server:latest"; # https://github.com/Theofilos-Chamalis/mumble-web
    #   volumes = [
    #     "${ cfg.dataDir }/mumble:/data"
    #   ];
    #   ports = [ "64738:64738" ];
    #   environment = {
    #     MUMBLE_CONFIG_WELCOMETEXT = "Welcome to the Shire! Have a grand time and don't disturb the hobbits!";
    #     MUMBLE_SUPERUSER_PASSWORD = "${ mumble_superpassword }";
    #   };
    # };
    
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
  };
}
