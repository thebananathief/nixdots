{ pkgs, ... }: {
  imports = [
    ../games.nix
  ];
  
  services.xserver.desktopManager.cinnamon = {
    enable = true;
  };
}
