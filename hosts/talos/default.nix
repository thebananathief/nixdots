{ pkgs, ... }: {
  imports = [ 
    ./hardware-configuration.nix
    ./packages.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  networking = {
    hostName = "talos";
    networkmanager.enable = true;
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };

  # SMB share
#  fileSystems."/mnt/talos/storage" = {
#   device = "//talos/storage";
#   fsType = "cifs";
#   options = [
#
#   ];
#  }

  users.users.cameron = {
    isNormalUser = true;
    description = "Cameron";
    extraGroups = [ "networkmanager" "wheel" "network" ];
  };

  system.stateVersion = "23.05";
}
