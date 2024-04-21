{ pkgs, ... }: {
  imports = [
    # ./plasma.nix # includes games
    # ./hyprland.nix
    ./cinnamon.nix
    # ./sway.nix
    # ./gnome.nix
    # ./xfce.nix
    ../fonts.nix
  ];
  
  # make HM-managed GTK stuff work
  programs.dconf.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";

    # excludePackages = [ pkgs.xterm ];

    libinput = {
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
  };
}
