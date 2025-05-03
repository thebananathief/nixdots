{
  pkgs,
  # nixos-cosmic,
  ...
}: {
  imports = [
    ../games.nix
  ];
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };
}
