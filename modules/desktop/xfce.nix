{ pkgs, ... }: {
  services.xserver = {
    desktopManager.xfce.enable = true;
    displayManager.defaultSession = "xfce";
  };

  environment.systemPackages = (with pkgs; [
    
  ]) ++ (with pkgs.libsForQt5; [

  ]);
}
