{ config, ... }:
{
  services = {
    matrix-conduit = {
      enable = true;
      settings.global = {
        port = 6167;
        max_request_size = 20000000;
        allow_registration = true;
        allow_federation = true;
        allow_check_for_updates = true;
        allow_encryption = true;
        server_name = "chat.${config.networking.fqdn}";
        trusted_servers = [
          "matrix.org"
        ];
        address = "::1"; #loopback ipv6
      };
    };
  };
}
