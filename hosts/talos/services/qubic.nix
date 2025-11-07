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
        qubic_wallet_balance = {
          type = "http_client";
          endpoint = "https://rpc.qubic.org/v1/balances/QPLAGCFYRISNRGUHSTUDOQJGJLJCLSALDNORGFIBCEISWCGZZZMZIZCAXDBK";
          method = "GET";
          request.headers = {
            Accept = "application/json";
          };
          scrape_timeout_secs = 10;
          scrape_interval_secs = 300; # Poll every 5 minutes
          decoding.codec = "json";
        };

        qubic_price_usd = {
          type = "http_client";
          endpoint = "https://api.coingecko.com/api/v3/simple/price?ids=qubic-network&vs_currencies=usd";
          method = "GET";
          request.headers = {
            Accept = "application/json";
          };
          scrape_timeout_secs = 10;
          scrape_interval_secs = 300; # Poll every 5 minutes
          decoding.codec = "json";
        };

        journald_qubic = {
          type = "journald";
          include_units = [ "podman-qubic-client.service" ];
          current_boot_only = true;
        };
      };

      transforms = {
        parse_qubic_wallet_balance = {
          type = "remap";
          inputs = [ "qubic_wallet_balance" ];
          # Example log: 2025-11-07 03:09:45.062 [INFO]  E:186 | SHARES: 0/0 (R:0) | 1876 it/s | 1863 avg it/s\n
          source = ''
            .walletId = string!(.balance.id)
            .balance = to_int!(.balance.balance)
          '';
        };
        
        parse_qubic_to_usd = {
          type = "remap";
          inputs = [ "qubic_price_usd" ];
          # Example log: 2025-11-07 03:09:45.062 [INFO]  E:186 | SHARES: 0/0 (R:0) | 1876 it/s | 1863 avg it/s\n
          source = ''
            .usd = to_int!(.qubic-network.usd)
            del(.qubic-network)
          '';
        };

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
            .shares = parsed.shares
            .hashrate = to_int!(replace(parsed.hashrate, " it/s", ""))
            .avg_hashrate = to_int!(replace(parsed.avg_hashrate, " avg it/s", ""))
            
            # Use log's timestamp if valid, else system time
            log_time = parse_timestamp(parsed.timestamp, "%Y-%m-%d %H:%M:%S.%3f") ?? now()
            .timestamp = log_time
          '';
        };
      };

      sinks = {
        influxdb_logs = {
          type = "influxdb_logs";
          inputs = [ "parse_qubic_logs" ];
          endpoint = "http://localhost:8086";
          measurement = "qubic_logs2";
          bucket = "mybucket";
          org = "myorg";
          token = "g4pdIgFgeaW9d5qg4Am7xuWVlZbv9t2W_D47j9TRteDNTt74QTsEH36p1V6xcp1Lj_O4MsQD-L8wVl0kG7tvug==";
        };
        debug_console = {
          type = "console";
          inputs = [ "parse_qubic_wallet_balance" "parse_qubic_to_usd" ];
          encoding.codec = "json";
          encoding.json.pretty = true;
        };
      };
    };
  };
}