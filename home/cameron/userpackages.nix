{ pkgs, lib, inputs, globalFonts, ... }: rec {
  home.packages = with pkgs; [
    # forge-mtg
    vscode-fhs
    mysql-shell
    # mcrcon # minecraft rcon client
    # moonlight-qt
    # gramps
    # tesseract
    dbeaver
    mysql-workbench
    spicetify-cli

    audacity
    obsidian
    localsend
    # webcord
    armcord
    # discord
    bitwarden
    spotify
  ];
}
