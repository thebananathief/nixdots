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
              "localhost:9753"
              "localhost:9436"
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
            bgp = false;
            dhcp = true;
            dhcpv6 = false;
            dhcpl = false;
            routes = true;
            pools = true;
            optics = true;
          };
        };
      };
      restic = {
        enable = true;
        environmentFile = pkgs.writeText "restic-exporter.env" ''
        PATH=${pkgs.openssh}/bin/
        '';
        repository = "sftp://restic@icebox:22//mnt/backup/talos";
        passwordFile = secrets.restic_talos_backup.path;
        user = "root";
      };
    };
  };

  
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
