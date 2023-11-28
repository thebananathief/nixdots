{ pkgs, ... }: {
  services.xserver = {
    desktopManager.xfce.enable = true;
    displayManager.defaultSession = "xfce";
  };

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
