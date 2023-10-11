{ pkgs, ... }: {
  imports = [
    ../../modules/games.nix
  ];
  environment.systemPackages = with pkgs; [
  ## CLI
    fzf
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
    fd
    dua
    ffmpegthumbnailer
    efibootmgr
    #cut

  ## Coding
    go
    nodejs-slim
    rustup

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