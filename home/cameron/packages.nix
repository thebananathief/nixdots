{ pkgs, lib, inputs, globalFonts, ... }: rec {
  home.packages = with pkgs; [
    # forge-mtg
    vscode-fhs
    mysql-shell
    # mcrcon # minecraft rcon client
    # moonlight-qt
    # gramps
    # tesseract
  ];
}
