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
  
  
  # Log monitoring
  services.vector = {
    enable = true;
    journaldAccess = true;
  };
  imports = [
    ../../../modules/monitoring/qubic_logs.nix
  ];
}