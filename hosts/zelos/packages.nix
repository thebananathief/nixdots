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
    alacritty
    wgnord
    cage
    zig
    ranger
    wev
    imagemagick
    broot
    fzf
    fd
    dua
    ffmpegthumbnailer
    efibootmgr
    nixfmt
    #cut

  ## Coding
    go
    nodejs-slim
    rustup
    vscodium

  ## General desktop
    krita
    libreoffice
    firefox
    megacmd
    obsidian
    spotify spicetify-cli
    discord
    bitwarden
    # starship
    # thunderbird
    # parsec-bin
  ];
}
