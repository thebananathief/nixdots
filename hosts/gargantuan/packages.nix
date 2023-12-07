{ pkgs, ... }: {
  # Sets up mullvad vpn stuff, we chose the GUI set of tools (pkgs.mullvad-vpn)
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  environment.systemPackages = with pkgs; [
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
    audacity
    # discord
    webcord
    bitwarden
    # thunderbird
    # parsec-bin
  ];
}
