{ pkgs, ... }: {
  # imports = [
  #   ../games.nix
  # ];

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
      desktopManager.plasma5.enable = true;
    # excludePackages = [ pkgs.xterm ];
    };
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
#    displayManager.defaultSession = "plasmawayland";
  };
  # services.desktopManager.plasma6.enable = true;

  # environment.systemPackages = (with pkgs; [
  #
  # ]) ++ (with pkgs.libsForQt5; [
  #
  # ]);

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

  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   plasma-browser-integration
  #   konsole
  #   oxygen
  # ];
}
