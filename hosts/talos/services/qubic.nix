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
        cpuThreads = 2;
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
        "/etc/timezone:/etc/timezone:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      devices = [
        "/dev/dri:/dev/dri"
      ];
    };
  };

  boot.kernel.sysctl = { "vm.nr_hugepages" = 512; };
}