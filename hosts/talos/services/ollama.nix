{ pkgs, lib, sops-nix, config, ... }: {
  environment.systemPackages = with pkgs; [
    python3
    poetry
    gnumake
    # pyenv
    gcc_multi
    libstdcxx5
    # libgccjit
    # binutils_nogold
  ];

  services.ollama = {
    enable = true;
    host = "[::]";
    port = 11434;
    # acceleration = "cuda";
    openFirewall = true;
    loadModels = [ 
      "llama3.2:3b" 
      "deepseek-r1:1.5b"
    ];
  };
  services.qdrant = {
    enable = true;
    settings = {
      storage = {
        storage_path = "/var/lib/qdrant/storage";
        snapshots_path = "/var/lib/qdrant/snapshots";
      };
      # hsnw_index = {
      #   on_disk = true;
      # };
      service = {
        host = "127.0.0.1";
        http_port = 3000;
        grpc_port = 3001;
      };
      # telemetry_disabled = true;
    };
  };
}
