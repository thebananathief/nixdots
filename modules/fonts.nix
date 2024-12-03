{ pkgs, globalFonts, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = (with pkgs; [
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
      # (nerdfonts.override { fonts = [ 
      #   "JetBrainsMono"
      #   "FiraCode"
      #   "FiraMono"
      #   "Meslo"
      #   "MPlus"
      #   "RobotoMono"
      # ];})
    ]) ++ (with pkgs.nerd-fonts; [
      jetbrains-mono
      fira-code
      fira-mono
      meslo-lg
      mplus
      roboto-mono
    ]);
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      serif = [globalFonts.serif "Noto Color Emoji"];
      sansSerif = [globalFonts.sansSerif "Noto Color Emoji"];
      monospace = [globalFonts.monospace "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
    
# valid font names https://github.com/NixOS/nixpkgs/blob/6ba3207643fd27ffa25a172911e3d6825814d155/pkgs/data/fonts/nerdfonts/shas.nix
# 'fonts' function will search all installed fonts
