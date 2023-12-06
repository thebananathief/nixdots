{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mullvad-vpn
  ## CLI
    btop
    # cage
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

  ## Coding
    zig
    go
    nodejs_20
    rustup
    dbeaver

    vscodium
    jetbrains.idea-community

  ## General desktop
    alacritty
    # krita
    # libreoffice
    firefox
    megacmd
    obsidian
    # zettlr
    spotify
    spicetify-cli
    discord
    bitwarden
    # thunderbird
    # parsec-bin
  ];
}
