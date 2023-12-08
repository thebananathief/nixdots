{ pkgs, ... }: {
  services.mullvad-vpn.enable = true;
  # pkgs.mullvad for CLI only, pkgs.mullvad-vpn for CLI and GUI
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  environment.systemPackages = with pkgs; [
  ## CLI
    btop
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

    jetbrains.idea-community

  ## General desktop
    alacritty
    firefox
    # TODO: setup some flake shit to automatically log in and create the sync
    megacmd
    audacity
    spicetify-cli # Needs to be installed even with the flake
    
  ## Electron apps
    vscodium
    obsidian
    webcord 
    bitwarden
    spotify 
    
    # thunderbird
    # parsec-bin
    # krita
    # libreoffice
    # zettlr
    # discord
    # dbeaver
    # cage
  ];
}
