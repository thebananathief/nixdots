{ config, pkgs, ... }:
{
  services.dnsmasq = {
    enable = true;
    settings = {
      # Upstream DNS servers for non-local queries (e.g., internet resolution)
      server = [
        "1.1.1.1"
        "8.8.8.8"
        "8.8.4.4"
        "9.9.9.9"
      ];
      
      # Wildcard resolution: All *.talos.home.arpa resolves to your server's IP
      address = [
        "/talos.home.arpa/192.168.0.12"
        "/talos/192.168.0.12"
        "/styx/192.168.0.13"
        "/homeassistant.local/192.168.0.14"
      ];
      
      # Treat these domains as local (no forwarding to upstream, authoritative)
      local = [
        "/talos.home.arpa/"
        "/local/"  # Makes *.local local-only
      ];

      # Bind only to specific IPs to avoid container network conflicts
      listen-address = [
        "192.168.0.12"
        "127.0.0.1"     # Loopback for local queries
        "::1"
      ];
      
      # Enforce binding only to specified addresses/interfaces
      bind-interfaces = true;
    };
  };

  # Open firewall ports for DNS (UDP and TCP)
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}