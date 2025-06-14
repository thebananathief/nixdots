{ config, username, pkgs, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  
  services.grafana = {
    enable = true;
    settings.server.http_addr = "0.0.0.0";
    settings.server.http_port = 3000;
  };

  # SMART
  services.smartd = {
    enable = true;
    # devices = [
    # ];
  };

  sops.secrets.restic_talos_backup = {};

  services.prometheus = {
    enable = true;
    # port = 9090;
    retentionTime = "4w";
    webExternalUrl = "https://prometheus.${ config.networking.fqdn }";
    scrapeConfigs = [
      {
        job_name = "talos";
        scrape_interval = "1m";
        scrape_timeout = "10s";
        static_configs = [
          {
            targets = [
              "localhost:9100" # node exporter
              # "localhost:9256" # process exporter
              # "localhost:9558" # systemd exporter
              "localhost:9633" # smartctl exporter
              "localhost:49090" # docker mktxp exporter
              # "localhost:9436" # crappy mikrotik exporter
              # "localhost:9753"
            ];
          }
        ];
      }
      {
        job_name = "icebox";
        scrape_interval = "1m";
        scrape_timeout = "10s";
        static_configs = [
          {
            targets = [
              "icebox:9100"
              "icebox:9633"
            ];
          }
        ];
      }
      {
        job_name = "icebox2";
        scrape_interval = "1m";
        scrape_timeout = "10s";
        static_configs = [
          {
            targets = [
              "icebox2:9100"
              "icebox2:9633"
            ];
          }
        ];
      }
    ];
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "systemd"
        ];
      };
      # process = {
      #   enable = true;
      # };
      # systemd = {
      #   enable = true;
      # };
      smartctl = {
        enable = true;
        maxInterval = "60s";
      };

      # mikrotik = {
      #   enable = true;
      #   configuration = {
      #     devices = [
      #       {
      #         name = "router";
      #         address = "192.168.0.1";
      #         user = "prometheus";
      #         password = "changeme";
      #       }
      #       {
      #         name = "ap";
      #         address = "192.168.0.50";
      #         user = "prometheus";
      #         password = "changeme";
      #       }
      #     ];
      #     features = {
      #       bgp = true;
      #       dhcp = true;
      #       dhcpv6 = true;
      #       dhcpl = true;
      #       routes = true;
      #       pools = true;
      #       optics = true;
      #     };
      #   };
      # };

      # restic = {
      #   enable = true;
      #   environmentFile = pkgs.writeText "restic-exporter.env" ''
      #   PATH=${pkgs.openssh}/bin/
      #   '';
      #   repository = "sftp://restic@icebox:22//mnt/backup/talos";
      #   passwordFile = secrets.restic_talos_backup.path;
      # };
    };
  };

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
    # cp ${mktxpConfigFile} /var/lib/mktxp/mktxp.conf

      # mktxpConfig = pkgs.runCommand "mktxp" {} ''
      #   cp ${mktxpConfigFile} $out/mktxp.conf
      #   chmod 644 $out
      # '';
      # mktxpConfig = pkgs.writeTextFile {
      #   name = "mktxp.conf";
      #   mode = "0644";
      #   text = (pkgs.lib.generators.toINI {} {
      #   });
      # };

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

  services.caddy.virtualHosts = {
    "prometheus.${ config.networking.fqdn }".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:9090
    '';
    "grafana.${ config.networking.fqdn }".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:3000
    '';
  };
}
