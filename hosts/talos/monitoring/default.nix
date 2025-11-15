{config, username, pkgs, ...}: let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  imports = [
    ./monitor_qubic.nix
    ./mktxp.nix
    # ./influxdb.nix
    ./smokeping.nix
  ];
  
  services.grafana = {
    enable = true;
    settings.server.http_addr = "127.0.0.1";
    settings.server.http_port = 3000;
  };

  services.vector = {
    enable = true;
    journaldAccess = true;
    # settings = {
    #   sources.host_metrics.type = "host_metrics";
    #   sinks.influxdb_host_metrics = {
    #     type = "influxdb_metrics";
    #     inputs = [ "host_metrics" ];
    #     endpoint = "http://localhost:8086";
    #     bucket = "mybucket";
    #     org = "myorg";
    #     token = "g4pdIgFgeaW9d5qg4Am7xuWVlZbv9t2W_D47j9TRteDNTt74QTsEH36p1V6xcp1Lj_O4MsQD-L8wVl0kG7tvug==";
    #   };
    # };
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
              "localhost:9598" # Vector sink
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
              "icebox:9598" # Vector sink
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
              "gridur:9100"
              "gridur:9633"
              "gridur:9598" # Vector sink
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