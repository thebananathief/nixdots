{ pkgs, lib, sops-nix, config, ... }: {
  environment.systemPackages = with pkgs; [
    python3
    poetry
    gnumake
    pyenv
    gcc_multi
    # libgccjit
    # binutils_nogold
  ];

  services.ollama = {
    enable = true;
    listenAddress = "127.0.0.1:11434";
    acceleration = "cuda";
  };
}
