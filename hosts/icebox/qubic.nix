{config, pkgs, ...}: let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;

  configFileContent = builtins.toJSON {
    ClientSettings = {
      poolAddress = "wss://wps.qubic.li/ws";
      alias = "qli Icebox";
      trainer = {
        cpu = true;
        gpu = false;
        # gpuVersion = "CUDA";
        cpuVersion = "AVX2";
        cpuThreads = 4;
      };
      pps = true;
      accessToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6Ijk2NDZkOTgzLWQ2OGQtNDBhMS1hMGZjLWE0MTMxM2FkODU1MiIsIk1pbmluZyI6IiIsIm5iZiI6MTc2MDY3OTg5OSwiZXhwIjoxNzkyMjE1ODk5LCJpYXQiOjE3NjA2Nzk4OTksImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.G9VJVpRXPj2xraZBbIFtUwFQbkQMrYzNOPthHomeUH0VvZljfg5tv_v6ivw5LaTStG4-myUMY7wKSNnyksaf8GssDfw0cUXlmbgJT9aK15wqBVPzuKRHGKbK6HX8MY1RqrhCShV9UeFhUKFd4SCG8M3Kz4k8kfMc_GHvKHz1d4YpzjmKCHdczHwQwiNPyPIisTFNpmxBr3fIGKLJsn17P2nGancGdrcuR6Vb97HfedSactNlf45x3XT67LHqCLtMS1_-rkp9oewN-6Jyfr0sK6P8YTcNhJRrHufGa4OUzVuN8E47edeLu-L9GNongpi0GR5Iwl5fBjNb6Vtbjt451w";
      qubicAddress = null;
      idling = null;
    };
  };

  qubicConfig = pkgs.writeText "appsettings.json" configFileContent;
in {
  users = {
    groups.qubic = {};
    users.qubic = {
      group = "qubic";
      isSystemUser = true;
    };
  };

  systemd.services."podman-qubic-client".restartTriggers = [
    qubicConfig
  ];
  systemd.services."fluent-bit".restartTriggers = [
    qubicConfig
  ];

  # sops.secrets = {
  #   "qubic-client.env" = {};
  # };

  virtualisation.oci-containers.containers = {
    qubic-client = {
      image = "qliplatform/qubic-client:latest";
      pull = "newer";
      # podman.user = "qubic";
      volumes = [
        "${ qubicConfig }:/app/appsettings.json:ro"
        "/dev/hugepages:/dev/hugepages"
      ];
      devices = [
        "/dev/dri:/dev/dri"
      ];
    };
  };

  boot.kernel.sysctl = { "vm.nr_hugepages" = 512; };
  
  services.fluent-bit = {
    enable = true;
    settings = {
      service = {
        flush = 1;
        log_level = "info";
        daemon = false;
      };

      parsers = [
        {
          name = "qubic-parser";
          format = "regex";
          regex = ''^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3} \[INFO\]  E:(?<epoch>\d+) \| SHARES: (?<shares_accepted>\d+)/(?<shares_total>\d+) \(R:(?<shares_rejected>\d+)\) \| (?<its>\d+) it/s \| (?<avg_its>\d+) avg it/s$'';
          time_key = "time";
          time_format = "%Y-%m-%d %H:%M:%S.%L";
        }
      ];

      inputs = [
        {
          name = "systemd";
          tag = "qubic-client-logs";
          systemd_filter = {
            _SYSTEMD_UNIT = "podman-qubic-client.service";
          };
          read_from_tail = true;
        }
      ];

      filters = [
        {
          name = "parser";
          match = "qubic-client-logs";
          key_name = "MESSAGE";
          parser = "qubic-parser";
          reserve_data = true;
        }
        {
          name = "log_to_metrics";
          match = "qubic-client-logs";
          mode = "gauge";
          metrics = [
            {
              name = "qubic_epoch";
              description = "Current qubic epoch";
              value_key = "epoch";
              labels = {
                instance = "$HOSTNAME";
                container = "qubic-client";
              };
            }
            {
              name = "qubic_shares_accepted";
              description = "Accepted shares";
              value_key = "shares_accepted";
              labels = {
                instance = "$HOSTNAME";
                container = "qubic-client";
              };
            }
            {
              name = "qubic_shares_total";
              description = "Total shares";
              value_key = "shares_total";
              labels = {
                instance = "$HOSTNAME";
                container = "qubic-client";
              };
            }
            {
              name = "qubic_shares_rejected";
              description = "Rejected shares";
              value_key = "shares_rejected";
              labels = {
                instance = "$HOSTNAME";
                container = "qubic-client";
              };
            }
            {
              name = "qubic_iterations_per_sec";
              description = "Iterations per second";
              value_key = "its";
              labels = {
                instance = "$HOSTNAME";
                container = "qubic-client";
              };
            }
            {
              name = "qubic_avg_iterations_per_sec";
              description = "Average iterations per second";
              value_key = "avg_its";
              labels = {
                instance = "$HOSTNAME";
                container = "qubic-client";
              };
            }
          ];
        }
      ];

      outputs = [
        {
          name = "prometheus_exporter";
          match = "qubic-client-logs";
          host = "127.0.0.1";
          port = 9200;
        }
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 9200 ];
}