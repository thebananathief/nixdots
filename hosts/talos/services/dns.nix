{ config, pkgs, ... }:
{
  services.dnsmasq = {
    enable = true;
    settings = {
      # Upstream DNS servers for non-local queries (e.g., internet resolution)
      server = [
        "9.9.9.9"
        "8.8.8.8"
        "8.8.4.4"
      ];
      
      # Wildcard resolution: All *.talos.home.arpa resolves to your server's IP
      address = ["/talos.home.arpa/192.168.0.12"];
      
      # Treat this domain as local (no forwarding to upstream)
      local = "/talos.home.arpa/";
      
      # Listen on all interfaces to serve the local network
      bind-interfaces = false;
    };
  };

  # Open firewall ports for DNS (UDP and TCP)
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}