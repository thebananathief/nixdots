{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
  ## CLI
    neofetch
    btop
    ethtool
    just
    universal-ctags
    dos2unix
    tldr
    wgnord
    cage
    zig
    wev
    dua
    efibootmgr
    jsonfmt
    #cut

  ## Coding
    go
    nodejs-slim
    rustup
    vscodium

  ## General desktop
    alacritty
    krita
    libreoffice
    firefox
    megacmd
    obsidian
    spotify
    spicetify-cli
    discord
    bitwarden
    # thunderbird
    # parsec-bin
  ];
}
