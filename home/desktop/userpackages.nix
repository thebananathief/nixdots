{
  pkgs,
  lib,
  inputs,
  globalFonts,
  ...
}: rec {
  home.packages = with pkgs; [
    # forge-mtg
    # mcrcon # minecraft rcon client
    # moonlight-qt
    # gramps
    # tesseract
    firefox
    tailscale-systray
    spotify
    obsidian
    localsend
    bitwarden
    # webcord
    legcord
    # discord
    # ripcord

    vscode-fhs
    zed-editor
    mysql-shell
    audacity
    alacritty
    ghostty
    dbeaver-bin
    bambu-studio
    blender
  ];
}
