{ pkgs, ... }: {
  services.xserver.desktopManager.cinnamon = {
    enable = true;
  };
}
