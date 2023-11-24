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
    tailspin
    bat
    #cut

  # Fun stuff
    cava # audio visualizer
    cmatrix

    (python311.withPackages (ps: 
      with ps; [
        ansible
        yamllint
    ]))

  ## Coding
    go
    nodejs-slim
    rustup
    vscodium
    dbeaver
    jetbrains.idea-community

  ## General desktop
    alacritty
    krita
    libreoffice
    firefox
    megacmd
    obsidian
    zettlr
    spotify
    spicetify-cli
    discord
    bitwarden
    # thunderbird
    parsec-bin
  ];
}
