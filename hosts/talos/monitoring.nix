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
    scrapeConfigs = [
      {
        job_name = "talos";
        scrape_interval = "1m";
        scrape_timeout = "10s";
        static_configs = [
          {
            targets = [
              "localhost:9100"
              "localhost:9633"
              # "localhost:49090"
              "localhost:9436"
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
    ];
    exporters = {
      node = {
        enable = true;
      };
      smartctl = {
        enable = true;
        maxInterval = "60s";
      };
      mikrotik = {
        enable = true;
        configuration = {
          devices = [
            {
              name = "router";
              address = "192.168.0.1";
              user = "prometheus";
              password = "changeme";
            }
            {
              name = "ap";
              address = "192.168.0.50";
              user = "prometheus";
              password = "changeme";
            }
          ];
          features = {
            bgp = true;
            dhcp = true;
            dhcpv6 = true;
            dhcpl = true;
            routes = true;
            pools = true;
            optics = true;
          };
        };
      };
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

  # Docker container for mikrotik exporter
  # virtualisation.oci-containers.containers = {
  #   mktxp = let
  #     mktxpConfig = pkgs.runCommand "mktxp.conf" {} ''
  #       echo '${pkgs.lib.generators.toINI {} {
  #         "Router" = {
  #           hostname = "192.168.0.1";
  #         };
  #         "Access Point" = {
  #           hostname = "192.168.0.50"; 
  #         };
  #         default = {
  #           enabled = true;
  #           hostname = "localhost";
  #           port = 8728;
  #           username = "prometheus";
  #           password = "changeme";
  #           use_ssl = false;
  #           no_ssl_certificate = false;
  #           ssl_certificate_verify = false;
  #           plaintext_login = true;
  #           installed_packages = true;
  #           dhcp = true;
  #           dhcp_lease = true;
  #           connections = true;
  #           connection_stats = false;
  #           interface = true;
  #           route = true;
  #           pool = true;
  #           firewall = true;
  #           neighbor = true;
  #           dns = false;
  #           ipv6_route = false;
  #           ipv6_pool = false;
  #           ipv6_firewall = false;
  #           ipv6_neighbor = false;
  #           poe = true;
  #           monitor = true;
  #           netwatch = true;
  #           public_ip = true;
  #           wireless = true;
  #           wireless_clients = true;
  #           capsman = true;
  #           capsman_clients = true;
  #           eoip = false;
  #           gre = false;
  #           ipip = false;
  #           lte = false;
  #           ipsec = false;
  #           switch_port = false;
  #           kid_control_assigned = false;
  #           kid_control_dynamic = false;
  #           user = true;
  #           queue = true;
  #           bgp = false;
  #           routing_stats = false;
  #           certificate = false;
  #           remote_dhcp_entry = null;
  #           remote_capsman_entry = null;
  #           use_comments_over_names = true;
  #           check_for_updates = false;
  #         };
  #       }}' > $out/mktxp.conf
  #       chmod 644 $out
  #     '';
  #     # mktxpConfig = pkgs.writeTextFile {
  #     #   name = "mktxp.conf";
  #     #   mode = "0644";
  #     #   text = (pkgs.lib.generators.toINI {} {
  #     #   });
  #     # };
  #   in {
  #     image = "ghcr.io/akpw/mktxp:latest";
  #     volumes = [
  #       "${ mktxpConfig }:/home/mktxp/mktxp/mktxp.conf:ro"
  #     ];
  #     ports = [ "49090:49090" ];
  #   };
  # };

  services.caddy.virtualHosts = {
    "grafana.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:3000
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}
