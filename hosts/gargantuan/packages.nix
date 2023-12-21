{ pkgs, ... }: {
  services.mullvad-vpn.enable = true;
  # pkgs.mullvad for CLI only, pkgs.mullvad-vpn for CLI and GUI
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  environment.systemPackages = with pkgs; [
    wev
    efibootmgr
    jsonfmt
    cava # audio visualizer
    cmatrix
    go
    pre-commit

    (python311.withPackages (ps:
      with ps; [
        ansible
    ]))

  ## General desktop
    alacritty
    firefox
    # TODO: setup some flake shit to automatically log in and create the sync
    megacmd
    audacity
    spicetify-cli # Needs to be installed even with the flake
    localsend
    jetbrains.idea-community

    tailscale-systray
    kanshi

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

  pkgs.symlinkJoin {
    name = "spotify";
    paths = [ pkgs.spotify ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify \
        --enable-features=UseOzonePlatform \
        --ozone-platform=wayland
    '';
  }
}
