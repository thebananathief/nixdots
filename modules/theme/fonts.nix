{ pkgs, ... }:
let
  globalFont = import ./globalFonts.nix;
in {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      material-symbols
      noto-fonts
      noto-fonts-emoji
      roboto
      lexend
      jost
      fira
      garamond-libre
      gelasio
      libre-caslon
      (nerdfonts.override { fonts = [ 
        "JetBrainsMono"
        "FiraCode"
        "FiraMono"
        "Meslo"
        "MPlus"
        "RobotoMono"
      ];})
    ];
    fontconfig.defaultFonts = {
      serif = [globalFont.serif "Noto Color Emoji"];
      sansSerif = [globalFont.sansSerif "Noto Color Emoji"];
      monospace = [globalFont.monospace "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
    
# valid font names https://github.com/NixOS/nixpkgs/blob/6ba3207643fd27ffa25a172911e3d6825814d155/pkgs/data/fonts/nerdfonts/shas.nix
# 'fonts' function will search all installed fonts
