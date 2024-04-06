{ pkgs, lib, sops-nix, config, ... }: {
  environment.systemPackages = with pkgs; [
    python3
    poetry
  ];

  services.ollama = {
    enable = true;
    listenAddress = "127.0.0.1:11434";
    acceleration = "cuda";
  };
}
