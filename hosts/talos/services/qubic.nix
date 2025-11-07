{config, pkgs, ...}: let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;

  configFileContent = builtins.toJSON {
    ClientSettings = {
      poolAddress = "wss://wps.qubic.li/ws";
      alias = "qli Talos";
      trainer = {
        cpu = true;
        gpu = false;
        gpuVersion = "CUDA";
        cpuVersion = "AVX512";
        cpuThreads = 3;
      };
      pps = true;
      accessToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6Ijk2NDZkOTgzLWQ2OGQtNDBhMS1hMGZjLWE0MTMxM2FkODU1MiIsIk1pbmluZyI6IiIsIm5iZiI6MTc0OTg3Mjk2NywiZXhwIjoxNzgxNDA4OTY3LCJpYXQiOjE3NDk4NzI5NjcsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.Sop7jqZgpArESaSZSItWcTWvBUEQK-fdVmxk4r64naMPhi1pmyHdWQyF-IHWBYTowEIyH3cZXXaBtZqOS8ZiHQG1SZsalcjHoc_jfNM0fl6uBRsdpTmxEjzPdyuSAKtHP8ycepSt68F1GYpokArJe_YN1XUxOQez2SYbZRwXO4kNobq6Oz96ISnJMdkvo7bjJbiHtNIDya6_oKPSJa8_yHlwzuTWn6vf3WdXP6ZwT_er5BsYBWoTkS9UDLVca68P8fPUHlaRgEFRtNPCNezBXKKgEr2M1Py2k9U2sOBL0pAHuK9XCu472t5UN8USqnQ49UpIl8_bnnbibkkvBKzzcA";
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
          units = [ "podman-qubic-client.service" ];
          current_boot_only = true;
        };
      };

      transforms = {
        parse_qubic_logs = {
          type = "remap";
          inputs = [ "journald_qubic" ];
          source = ''
            # Only process lines matching the pattern (skip non-metric logs)
            if !match(.message, r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3} \[\w+\] E:\d+ \| SHARES: \d+/\d+ \(R:\d+\) \| \d+ it/s \| \d+ avg it/s$') {
              abort
            }
            
            # Parse with regex
            parsed = parse_regex!(.message, r'^(?P<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}) \[(?P<level>\w+)\] (?P<epoch>E:\d+) \| SHARES: (?P<shares>\d+/\d+ \(R:\d+\)) \| (?P<hashrate>\d+ it/s) \| (?P<avg_hashrate>\d+ avg it/s)$')
            
            # Extract numerics
            .epoch = parsed.epoch
            .shares = parsed.shares
            .hashrate = to_int!(replace(parsed.hashrate, " it/s", "")) ?? 0
            .avg_hashrate = to_int!(replace(parsed.avg_hashrate, " avg it/s", "")) ?? 0
            
            # Use log's timestamp if valid, else system time
            log_time = parse_timestamp(parsed.timestamp, "%Y-%m-%d %H:%M:%S.%3f") ?? now()
            .timestamp = log_time
          '';
        };
      };

      sinks = {
        influxdb_metrics = {
          type = "influxdb";
          inputs = [ "parse_qubic_logs" ];
          endpoint = "http://localhost:8086";
          database = "qubic_metrics";
          measurement = "qubic_stats";
          namespace = "qubic";
          tags = {
            epoch = "{{ epoch }}";
            shares = "{{ shares }}";
          };
          fields = {
            hashrate = "{{ hashrate }}";
            avg_hashrate = "{{ avg_hashrate }}";
          };
          batch = {
            max_bytes = 1048576;
          };
          request = {
            retry_attempts = 5;
          };
        };
      };
    };
  };
}