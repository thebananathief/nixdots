{ pkgs, ... }: {
  # Configure X11, desktop, and keymap
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

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

  # For systray icons
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
  ];

#  environment.gnome.excludePackages = (with pkgs; [
#    gnome-photos
#    gnome-tour
#  ]) ++ (with pkgs.gnome; [
#    cheese # webcam tool
#    gnome-music
#    gnome-terminal
#    gedit # text editor
#    epiphany # web browser
#    geary # email reader
#    evince # document viewer
#    gnome-characters
#    totem # video player
#    tali # poker game
#    iagno # go game
#    hitori # sudoku game
#    atomix # puzzle game
#  ]);
}
