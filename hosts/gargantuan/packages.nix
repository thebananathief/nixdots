{ pkgs, ... }:
let
    # Fixed crashes from EGL something rather
    obsid = pkgs.symlinkJoin {
      name = "obsidian";
      paths = [ pkgs.obsidian ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/obsidian \
          --add-flags "--disable-gpu"
      '';
    };
in {
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
    mcrcon # minecraft rcon client
    wireguard-tools

    (python311.withPackages (ps:
      with ps; [
        ansible
    ]))

    alacritty
    firefox
    # TODO: setup some flake shit to automatically log in and create the sync
    megacmd
    audacity
    spicetify-cli # Needs to be installed even with the flake
    localsend
    # jetbrains.idea-community
    vscode-fhs
    obs-studio
    mumble
    zbar
    delfin
    bottles

    # tailscale-systray
    # trayscale
    ktailctl

  ## Electron apps
    obsid
    webcord
    # discord
    bitwarden
    spotify
    libreoffice-qt
    hunspell
    hunspellDicts.en_US

    # thunderbird
    # parsec-bin
    # krita
    # libreoffice
    # zettlr
    # dbeaver
    # cage
  ];
}
