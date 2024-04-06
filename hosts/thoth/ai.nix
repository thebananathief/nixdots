{ pkgs, lib, sops-nix, config, ... }: {
  environment.systemPackages = with pkgs; [
    python3
    poetry
    gnumake
    pyenv
    libgcc
  ];

  services.ollama = {
    enable = true;
    listenAddress = "127.0.0.1:11434";
    acceleration = "cuda";
  };
}
