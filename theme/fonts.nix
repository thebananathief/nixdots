{ pkgs, config, lib, ... }:
let
  sysVersion = config.system.nixos.release;
  onUnStable = lib.versionAtLeast sysVersion "23.11";
  fontPkgs = with pkgs; [
    material-symbols
    noto-fonts
    noto-fonts-emoji
    roboto
    lexend
    jost
    (nerdfonts.override { fonts = [ 
      "JetBrainsMono"
      "FiraCode"
      "FiraMono"
      "Meslo"
      "MPlus"
      "RobotoMono"
    ]; })
  ];
    # (
    #   # valid font names https://github.com/NixOS/nixpkgs/blob/6ba3207643fd27ffa25a172911e3d6825814d155/pkgs/data/fonts/nerdfonts/shas.nix

    #   polyBarIconFonts
    #   ++ [ (nerdfonts.override { fonts = myNerdFonts ++ polyBarNerdFonts; }) ]);
in {
  fonts = (if onUnStable then {
    enableDefaultPackages = true;
    packages = fontPkgs;
  } else {
    enableDefaultFonts = true;
    fonts = fontPkgs;
  }) // {
    # enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
