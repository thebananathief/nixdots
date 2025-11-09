{config, pkgs, ...}: let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;

  configFileContent = builtins.toJSON {
    ClientSettings = {
      poolAddress = "wss://wps.qubic.li/ws";
      alias = "qli Gridur";
      trainer = {
        cpu = true;
        gpu = true;
        # gpuVersion = "CUDA";
        cpuVersion = "AVX2";
        cpuThreads = 4;
      };
      pps = true;
      accessToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6Ijk2NDZkOTgzLWQ2OGQtNDBhMS1hMGZjLWE0MTMxM2FkODU1MiIsIk1pbmluZyI6IiIsIm5iZiI6MTc1MTIxNDQyMiwiZXhwIjoxNzgyNzUwNDIyLCJpYXQiOjE3NTEyMTQ0MjIsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.oojdKcwCkmqvMif_zVzcD4Ybw9QsLV_nGRWBRrSdzv1q_2c1K1S3WL5dFc4SudJJCErtYkQnjUPQcx95j3L9vyTjIExauIaEU11RMewndzjnw_2BSTv8Qr_r99sDUXWurBbthv5rvqWGaDo3dFrpkyX4ZeZIVHJPQ4s61d0yZ1zheG_AKQs8BfZ1E151iTeIKEU_2v8UDjllWaTQE-t0g1fsKGLlmT7bgJkZBUNmsNVkZzQUMUr1c7eWAift43G-Lrt875rk_sfpglSr7or4nZJO3CHZSPbEu-tngn-neZcBQriQMTxEzEtkII9hOO6sje3oh3_fJR4FRI7sYqqLPw";
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
          endpoint = "http://talos:8086";
          measurement = "qubic_logs2";
          bucket = "mybucket";
          org = "myorg";
          token = "g4pdIgFgeaW9d5qg4Am7xuWVlZbv9t2W_D47j9TRteDNTt74QTsEH36p1V6xcp1Lj_O4MsQD-L8wVl0kG7tvug==";
        };
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