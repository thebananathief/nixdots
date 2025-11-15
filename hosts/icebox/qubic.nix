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
  
  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      sources = {
        journald_qubic = {
          type = "journald";
          include_units = [ "podman-qubic-client.service" ];
          current_boot_only = true;
        };
      };

      transforms = {
        parse_qubic_logs = {
          type = "remap";
          inputs = [ "journald_qubic" ];
          # Example log: 2025-11-07 03:09:45.062 [INFO]  E:186 | SHARES: 0/0 (R:0) | 1876 it/s | 1863 avg it/s\n
          source = ''
            .message = string!(.message)

            # Only process lines matching the pattern (skip non-metric logs)
            if !match(.message, r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3} \[\w+\]\s+E:\d+\s+\|\s+SHARES:\s+\d+/\d+\s+\(R:\d+\)\s+\|\s+\d+ it/s\s+\|\s+\d+ avg it/s\s*$') {
              abort
            }
            
            # Parse with regex
            parsed = parse_regex!(.message, r'^(?P<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}) \[(?P<level>\w+)\]\s+E:(?P<epoch>\d+)\s+\|\s+SHARES:\s+(?P<shares>\d+/\d+\s+\(R:\d+\))\s+\|\s+(?P<hashrate>\d+ it/s)\s+\|\s+(?P<avg_hashrate>\d+ avg it/s)\s*$')
            
            # Extract numerics
            .epoch = to_int!(parsed.epoch)
            .hashrate = to_int!(replace(parsed.hashrate, " it/s", ""))
            .avg_hashrate = to_int!(replace(parsed.avg_hashrate, " avg it/s", ""))
            
            # Use log's timestamp if valid, else system time
            log_time = parse_timestamp(parsed.timestamp, "%Y-%m-%d %H:%M:%S.%3f") ?? now()
            .timestamp = log_time
          '';
        };
        parse_qubic_logs_metric = {
          type = "log_to_metric";
          inputs = [ "parse_qubic_logs" ];
          metrics = [
            {
              type = "gauge";
              kind = "absolute";
              name = "qubic.node_hashrate";
              field = ".hashrate";
              tags = {
                epoch = ".epoch";
              };
            }
            {
              type = "gauge";
              kind = "absolute";
              name = "qubic.node_hashrate_avg";
              field = ".avg_hashrate";
              tags = {
                epoch = ".epoch";
              };
            }
          ];
        };
      };

      sinks = {
        prom_qubic_log = {
          type = "prometheus_exporter";
          inputs = [ "parse_qubic_logs_metric" ];
        };
        # influxdb_logs = {
        #   type = "influxdb_logs";
        #   inputs = [ "parse_qubic_logs" ];
        #   endpoint = "http://talos:8086";
        #   measurement = "qubic_logs2";
        #   bucket = "mybucket";
        #   org = "myorg";
        #   token = "g4pdIgFgeaW9d5qg4Am7xuWVlZbv9t2W_D47j9TRteDNTt74QTsEH36p1V6xcp1Lj_O4MsQD-L8wVl0kG7tvug==";
        # };
        # debug_console = {
        #   type = "console";
        #   inputs = [ "parse_qubic_logs" ];
        #   encoding.codec = "json";
        #   encoding.json.pretty = true;
        # };
      };
    };
  };
}