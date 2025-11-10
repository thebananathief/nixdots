{config, pkgs, ...}: {
  # Generate config file
  system.activationScripts.mktxp-config = let
    mktxpConfig = pkgs.lib.generators.toINI {} {
      "Router" = {
        hostname = "192.168.0.1";
        # remote_capsman_entry = "Access Point";
      };
      "Access Point" = {
        hostname = "192.168.0.50"; 
        remote_dhcp_entry = "Router";
        wireless = true;
        wireless_clients = true;
      };
      default = {
        enabled = true;
        hostname = "localhost";
        port = 8728;
        username = "prometheus";
        password = "changeme";
        use_ssl = false;
        no_ssl_certificate = false;
        ssl_certificate_verify = false;
        plaintext_login = true;
        installed_packages = false;
        dhcp = true;
        dhcp_lease = true;
        connections = true;
        connection_stats = true;
        interface = true;
        route = true;
        pool = true;
        firewall = true;
        neighbor = true;
        dns = false;
        ipv6_route = false;
        ipv6_pool = false;
        ipv6_firewall = false;
        ipv6_neighbor = false;
        poe = false;
        monitor = true;
        netwatch = false;
        public_ip = true;
        wireless = false;
        wireless_clients = false;
        capsman = false;
        capsman_clients = false;
        eoip = false;
        gre = false;
        ipip = false;
        lte = false;
        ipsec = false;
        switch_port = false;
        kid_control_assigned = false;
        kid_control_dynamic = false;
        user = true;
        queue = true;
        bgp = false;
        routing_stats = false;
        certificate = false;
        remote_dhcp_entry = null;
        remote_capsman_entry = null;
        use_comments_over_names = true;
        check_for_updates = false;
      };
    };
  in ''
    mkdir -p /var/lib/mktxp
    echo '${mktxpConfig}' > /var/lib/mktxp/mktxp.conf
    chmod 644 /var/lib/mktxp/mktxp.conf
  '';

  # Docker container for mikrotik exporter
  virtualisation.oci-containers.containers = {
    mktxp = {
      image = "ghcr.io/akpw/mktxp:latest";
      pull = "newer";
      volumes = [ "/var/lib/mktxp:/home/mktxp/mktxp/" ];
      ports = [ "49090:49090" ];
    # User in the container is mktxp (uid=100,gid=101)
    };
  };
}