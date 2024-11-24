{ config, pkgs, ... }:
{
  services.bind = {
    enable = true;
    
    # Listen on all interfaces
    listenOn = [ "100.64.252.67" ];
    
    # Nameservers to forward requests to (upstream DNS servers)
    # By default, it'll forward to this server's nameservers
    # forwarding = [
    #   "8.8.8.8"
    # ];

    # Enable recursive DNS for private network
    # extraConfig = ''
    #   allow-recursion { 
    #     100.64.0.0/16;  # Tailscale network
    #     127.0.0.1/32;   # Localhost
    #   };
    # '';

    # Configure your DNS zones
    zones = {
      "talos.host" = {
        master = true;
        file = pkgs.writeText "talos.host" ''
        $TTL 86400
        @       IN      SOA     ns.talos.host. admin.talos.host. (
                                2024112401      ; Serial
                                3600            ; Refresh
                                1800            ; Retry
                                604800          ; Expire
                                86400 )         ; Negative Cache TTL

        ; Name servers
        @       IN      NS      ns.talos.host.

        ; A records for the name servers themselves
        ns      IN      A       100.64.252.67

        ; Other A records
        *       IN      A       100.64.252.67
        '';
      };
    };
  };

  # Open DNS ports in firewall
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}