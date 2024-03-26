{ pkgs, ... }: {
  imports = [
    ../games.nix
  ];

  services.xserver = {
    displayManager.sddm.enable = true;
#    displayManager.defaultSession = "plasmawayland";
    desktopManager.plasma5.enable = true;
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
