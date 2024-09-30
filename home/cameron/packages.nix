{ pkgs, lib, inputs, globalFonts, ... }: rec {
  home.packages = with pkgs; [
    # forge-mtg
    vscode-fhs
    # mcrcon # minecraft rcon client
    # moonlight-qt
    # gramps
    # tesseract
  ];
}
