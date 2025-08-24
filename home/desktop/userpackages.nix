{
  pkgs,
  lib,
  inputs,
  globalFonts,
  ...
}: rec {
  home.packages =
    (with pkgs; [
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
      # zed-editor
      # mysql-shell
      # audacity
      # alacritty
      dbeaver-bin
      # blender
      openscad

      go
      python312
    ])
    ++ (with pkgs.python312Packages; [
      solidpython2
      lnkparse3
    ]);
}
