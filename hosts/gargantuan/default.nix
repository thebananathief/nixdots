{ pkgs, ... }: {
  imports = [ 
    ./hardware-configuration.nix
    ./desktop.nix
    ./packages.nix
    ./power.nix
    ./fingerprint-reader.nix
    ../../modules/games.nix
    ../../theme
    ../../packages/fontpreview-ueberzug
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  networking = {
    hostName = "gargantuan";
    networkmanager.enable = true;
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };

  users.users.cameron = {
    isNormalUser = true;
    description = "Cameron";
    extraGroups = [ "networkmanager" "wheel" "network" "input" ];
  };

  system.stateVersion = "23.05";
}

