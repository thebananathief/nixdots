{ pkgs, lib, inputs, globalFonts, ... }: rec {
  home.packages = with pkgs; [
    # forge-mtg
    vscode-fhs
    mysql-shell
    # mcrcon # minecraft rcon client
    # moonlight-qt
    # gramps
    # tesseract
    dbeaver-bin
    bambu-studio
    blender

    audacity
    obsidian
    localsend
    # webcord
    legcord
    # discord
    # ripcord
    bitwarden
  ];
}
