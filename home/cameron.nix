{
  pkgs,
  lib,
  inputs,
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
    # these were outdated
    # opencode
    # opencode-desktop
    # claude-code
    # codex
  ];

  home.stateVersion = "23.05";

  home.sessionVariables = {
    # EDITOR = "hx";
  };
  home.sessionPath = [
    "${pkgs.bun}/bin"
  ];
}
