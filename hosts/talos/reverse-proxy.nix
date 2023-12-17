{ ... }:
{
  # Allow traffic in through HTTP and HTTPS ports,
  # caddy will handle it afterwards.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    virtualHosts = {
      "web.talos.host".extraConfig = ''
        reverse_proxy localhost:7008
        tls internal
      '';
    };
  };
}