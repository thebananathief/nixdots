{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
  ## CLI
    btop
    wgnord
    cage
    wev
    efibootmgr
    jsonfmt

  # Fun stuff
    cava # audio visualizer
    cmatrix

    (python311.withPackages (ps: 
      with ps; [
        ansible
        yamllint
    ]))

  ## Neovim
    tree-sitter
    universal-ctags

  ## Coding
    zig
    go
    nodejs_20
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
    # zettlr
    spotify
    spicetify-cli
    discord
    bitwarden
    # thunderbird
    parsec-bin
  ];
}
