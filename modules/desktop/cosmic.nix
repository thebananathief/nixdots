{ pkgs, nixos-cosmic, ... }: 
{
  imports = [ nixos-cosmic.nixosModules.default ];
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };
}
