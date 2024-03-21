{ config, lib, ... }:
with lib; {
  imports = [ ./containers.nix ];

  options.myOptions = {
    graphics.enable = mkEnableOption "Enable graphics";
    gestures.enable = mkEnableOption "Enable gestures";
    networkShares.enable = mkEnableOption "enable network shares";
  };
}
