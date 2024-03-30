{ pkgs, lib, inputs, globalFonts, ... }: rec {
  home.packages = with pkgs; [
    forge-mtg
  ];
}
