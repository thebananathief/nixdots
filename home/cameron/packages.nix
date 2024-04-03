{ pkgs, lib, inputs, globalFonts, ... }: rec {
  home.packages = with pkgs; [
    forge-mtg
    vscode-fhs
    pre-commit
    mcrcon # minecraft rcon client
    localsend
    wireguard-tools
    webcord
    # discord
    bitwarden
    spotify
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ];
}
