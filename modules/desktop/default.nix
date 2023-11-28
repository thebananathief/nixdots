{ pkgs, ... }: {
  imports = [
    # ./plasma.nix
    ./hyprland.nix
    # ./gnome.nix
    # ./xfce.nix
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";

    excludePackages = [ pkgs.xterm ];

    libinput = {
      enable = true;
      touchpad = {
        accelProfile = "flat";
        accelSpeed = "0.5";
        naturalScrolling = false;
      };
      mouse = {
        accelProfile = "flat";
        accelSpeed = "1.0";
        naturalScrolling = false;
      };
    };
  };
}
