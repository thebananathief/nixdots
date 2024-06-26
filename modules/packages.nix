{ pkgs, ... }:
let
    # Fixed crashes from EGL something rather
    # NVIDIA-wayland related?
    # obsid = pkgs.symlinkJoin {
    #   name = "obsidian";
    #   paths = [ pkgs.obsidian ];
    #   buildInputs = [ pkgs.makeWrapper ];
    #   postBuild = ''
    #     wrapProgram $out/bin/obsidian \
    #       --add-flags "--disable-gpu"
    #   '';
    # };
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
    # jetbrains.idea-community
    obs-studio
    mumble
    zbar
    delfin
    monero-gui

    tailscale-systray
    # trayscale
    # ktailctl

  ## Electron apps
    obsidian
    localsend
    wireguard-tools
    # webcord
    armcord
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
