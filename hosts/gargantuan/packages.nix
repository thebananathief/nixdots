{ pkgs, ... }: {
  imports = [
    ../../modules/games.nix
  ];
  environment.systemPackages = with pkgs; [
  ## CLI
    neofetch
    btop
    htop
    ethtool
    just
    wget
    universal-ctags
    tree
    multitail
    dos2unix
    tldr
    curl
    alacritty
    wgnord
    tmux
    cage
    autojump
    unzip
    zig
    ranger
    wev
    killall
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
    spotify
    spicetify-cli
    discord
    bitwarden
    # starship
    # thunderbird
    # parsec-bin
  ];
}
