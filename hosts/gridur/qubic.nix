{config, pkgs, ...}: let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;

  configFileContent = builtins.toJSON {
    ClientSettings = {
      poolAddress = "wss://wps.qubic.li/ws";
      alias = "qli Gridur";
      trainer = {
        cpu = true;
        # gpu = false;
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
}