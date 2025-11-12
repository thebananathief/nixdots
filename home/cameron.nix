{
  pkgs,
  lib,
  inputs,
  ...
}: rec {
  imports = [
    ./git.nix
    ./zsh.nix
  ];

  programs.home-manager.enable = true;
  home.username = "cameron";
  # home.homeDirectory = "/home/cameron";

  programs.opencode.enable = true;
  home.packages = with pkgs; [
    plandex
  ];

  home.stateVersion = "23.05";
}
