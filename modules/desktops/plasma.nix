{ pkgs, ... }: {
  # Configure X11, desktop, and keymap
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";

    displayManager.sddm.enable = true;
#    displayManager.defaultSession = "plasmawayland";
    desktopManager.plasma5.enable = true;

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

#   services.power-profiles-daemon.enable = lib.mkForce false;

  environment.systemPackages = (with pkgs; [
    
  ]) ++ (with pkgs.libsForQt5; [

  ]);

#  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
#    elisa
#    gwenview
#    okular
#    oxygen
#    khelpcenter
#    konsole
#    plasma-browser-integration
#    print-manager
#  ];
}
