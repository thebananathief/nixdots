{
  pkgs,
  lib,
  inputs,
  config,
  dotfiles,
  ...
}: rec {
  imports = [
    ./git.nix
    ./zsh.nix
    ./neovim.nix
  ];

  programs.home-manager.enable = true;
  home.username = "cameron";
  # home.homeDirectory = "/home/cameron";

  # programs.opencode.enable = true;
  home.packages = with pkgs; [
    bun
    nodejs_25
    # these were outdated
    # opencode
    # opencode-desktop
    # claude-code
    # codex
  ];

  home.stateVersion = "23.05";

  home.sessionVariables = {
    # EDITOR = "hx";
    DOTFILES_DIR = "${dotfiles}";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.bun/bin"
  ];
}
