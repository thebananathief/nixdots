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

  home.stateVersion = "23.05";

  home.sessionVariables = {
    EDITOR = "hx";
    PLANDEX_SKIP_UPGRADE = "1";
  };
  home.shellAliases = {
    pdx = "plandex-cli";
  };
}
