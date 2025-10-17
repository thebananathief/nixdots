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

  # Fluent Bit configuration for qubic-client metrics
  fluentBitConf = pkgs.writeText "fluent-bit-qubic.conf" ''
    [SERVICE]
        Flush         1
        Log_Level     info
        Daemon        off

    [INPUT]
        Name          systemd
        Tag           qubic-client-logs
        Systemd_Filter _SYSTEMD_UNIT=podman-qubic-client.service
        Read_From_Tail On

    [FILTER]
        Name          parser
        Match         qubic-client-logs
        Key_Name      MESSAGE
        Parser        qubic-parser
        Reserve_Data  On

    [FILTER]
        Name          log_to_metrics
        Match         qubic-client-logs
        Mode          gauge

        # Epoch
        Metric_Name   qubic_epoch
        Metric_Description Current qubic epoch
        Value_Key     epoch
        Label_Key     instance=$HOSTNAME container=qubic-client

        # Shares (0/0 format)
        Metric_Name   qubic_shares_accepted
        Metric_Description Accepted shares
        Value_Key     shares_accepted
        Label_Key     instance=$HOSTNAME container=qubic-client

        Metric_Name   qubic_shares_total
        Metric_Description Total shares
        Value_Key     shares_total
        Label_Key     instance=$HOSTNAME container=qubic-client

        Metric_Name   qubic_shares_rejected
        Metric_Description Rejected shares
        Value_Key     shares_rejected
        Label_Key     instance=$HOSTNAME container=qubic-client

        # Performance metrics
        Metric_Name   qubic_iterations_per_sec
        Metric_Description Iterations per second
        Value_Key     its
        Label_Key     instance=$HOSTNAME container=qubic-client

        Metric_Name   qubic_avg_iterations_per_sec
        Metric_Description Average iterations per second
        Value_Key     avg_its
        Label_Key     instance=$HOSTNAME container=qubic-client

    [OUTPUT]
        Name          prometheus_exporter
        Match         qubic-client-logs
        Host          127.0.0.1
        Port          9200
        
    [PARSER]
        Name        qubic-parser
        Format      regex
        Regex       ^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3} \[INFO\]  E:(?<epoch>\d+) \| SHARES: (?<shares_accepted>\d+)/(?<shares_total>\d+) \(R:(?<shares_rejected>\d+)\) \| (?<its>\d+) it/s \| (?<avg_its>\d+) avg it/s$
        Time_Key    time
        Time_Format %Y-%m-%d %H:%M:%S.%L
  '';
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
  
  # Fluent Bit service for Prometheus metrics
  services.fluent-bit = {
    enable = true;
    configurationFile = fluentBitConf;
  };
  networking.firewall.allowedTCPPorts = [ 9200 ];
}