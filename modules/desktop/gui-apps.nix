# TRYING TO OBSOLETE
{pkgs, ...}: let
  # Here we add some CLI arguments to the obsidian app
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
  # Try to use home-manager for GUI packages
  #   environment.systemPackages = with pkgs; [
  #     # obs-studio
  #     # mumble
  #     # delfin
  #     firefox
  #     tailscale-systray

  #     # libreoffice-qt
  #     # hunspell
  #     # hunspellDicts.en_US

  #     # thunderbird
  #     # krita
  #     # zettlr
  #     # cage
  #     # cava # audio visualizer

  # # Development / DBA
  #     # jetbrains.idea-community
  #     # jetbrains.goland
  #   ];

  # systemd.services.tailscale-systray = {
  #   description = "Tailscale system tray icon";
  #   wantedBy = [ "graphical.target" ];
  #   after = [ "tailscaled.service" ];
  #   wants = [ "tailscaled.service" ];
  #   path = [
  #     pkgs.tailscale-systray
  #   ];
  #   environment = {
  #     DISPLAY = "0";
  #   };
  #   startLimitBurst = 5;
  #   startLimitIntervalSec = 20;
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "cameron";
  #     ExecStart = "${pkgs.tailscale-systray}/bin/tailscale-systray";
  #     Restart = "always";
  #     RestartSec = 1;
  #   };
  # };
}
