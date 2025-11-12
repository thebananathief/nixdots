{
  pkgs,
  lib,
  inputs,
  ...
}: 
let
  plandex = pkgs.plandex.overrideAttrs (oldAttrs: rec {
    inherit (oldAttrs) pname;
    version = "2.2.1";
    src = pkgs.fetchFromGitHub {
      owner = "plandex-ai";
      repo = "plandex";
      rev = "cli/v${version}";
      hash = "sha256-xtK/6eK3Xm7vGgADsVzFOKaFI7E2uYFu/E/NiyeLWhk=";
    };
  });
in
rec {
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
