{ pkgs, ... }:
{
  services.mullvad-vpn.enable = true;
  # pkgs.mullvad for CLI only, pkgs.mullvad-vpn for CLI and GUI
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  environment.systemPackages = with pkgs; [
    # obs-studio
    # mumble
    # delfin
    firefox
    alacritty
    tailscale-systray

    # libreoffice-qt
    # hunspell
    # hunspellDicts.en_US

    # thunderbird
    # krita
    # zettlr
    # cage
    # cava # audio visualizer

# Development / DBA
    # jetbrains.idea-community
    # jetbrains.goland
  ];

  systemd.services.tailscale-systray = {
    description = "Tailscale system tray icon";
    wantedBy = [ "graphical.target" ];
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    path = [
      pkgs.tailscale-systray
    ];
    environment = {
      DISPLAY = "0";
    };
    startLimitBurst = 5;
    startLimitIntervalSec = 20;
    serviceConfig = {
      Type = "simple";
      User = "cameron";
      ExecStart = "${pkgs.tailscale-systray}/bin/tailscale-systray";
      Restart = "always";
      RestartSec = 1;
    };
  };
}