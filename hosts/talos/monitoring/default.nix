{config, username, pkgs, ...}: let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  imports = [
    ../../../modules/monitoring/qubic_logs.nix
    ./qubic_http.nix
    ./mktxp.nix
    # ./influxdb.nix
    ./smokeping.nix
    ./perses.nix
  ];
  
  services.grafana = {
    enable = true;
    settings.server.http_addr = "127.0.0.1";
    settings.server.http_port = 3000;
  };

  services.vector = {
    enable = true;
    journaldAccess = true;
  };

  # SMART
  services.smartd = {
    enable = true;
    # devices = [
    # ];
  };
  
  services.prometheus = {
    enable = true;
    # port = 9090;
    retentionTime = "4w";
    webExternalUrl = "https://prometheus.${ config.networking.fqdn }";
    scrapeConfigs = [
      {
        job_name = "qubic";
        scrape_interval = "30s";
        scrape_timeout = "10s";
        static_configs = [
          {
            targets = [
              "localhost:9599" # Vector qubic_http
              "localhost:9598" # Vector qubic_logs
              "icebox:9598" # Vector qubic_logs
              "gridur:9598" # Vector qubic_logs
            ];
          }
        ];
      }
      {
        job_name = "talos";
        scrape_interval = "1m";
        scrape_timeout = "10s";
        static_configs = [
          {
            targets = [
              # "localhost:9256" # process exporter
              # "localhost:9558" # systemd exporter
              "localhost:9100" # node exporter
              "localhost:9633" # smartctl exporter
              "localhost:49090" # docker mktxp exporter
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
              "icebox:9100" # node exporter
              "icebox:9633" # smartctl exporter
            ];
          }
        ];
      }
      {
        job_name = "gridur";
        scrape_interval = "1m";
        scrape_timeout = "10s";
        static_configs = [
          {
            targets = [
              "gridur:9100" # node exporter
              "gridur:9633" # smartctl exporter
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
      smartctl = {
        enable = true;
        maxInterval = "60s";
      };
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