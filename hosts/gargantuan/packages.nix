{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
  ## CLI
    neofetch
    btop
    ethtool
    just
    universal-ctags
    multitail
    dos2unix
    tldr
    wgnord
    cage
    zig
    wev
    imagemagick
    broot
    fzf
    fd
    dua
    ffmpegthumbnailer
    efibootmgr
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
    # starship
    # thunderbird
    # parsec-bin
  ];
}
