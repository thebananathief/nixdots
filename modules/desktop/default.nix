{pkgs, ...}: {
  imports = [
    ./plasma.nix # includes games
    # ./gui-apps.nix
    # ./gnome.nix
    # ./cinnamon.nix
    # ./sway.nix
    # ./xfce.nix
    # ./cosmic.nix
    # ./hyprland.nix

    ../fonts.nix
  ];

  # make HM-managed GTK stuff work
  programs.dconf.enable = true;

  services.libinput = {
    enable = true;
    touchpad = {
      accelProfile = "flat";
      accelSpeed = "0.0";
      naturalScrolling = false;
    };
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0.0";
      naturalScrolling = false;
    };
  };
}
