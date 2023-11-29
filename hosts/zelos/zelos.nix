{ pkgs, ... }: {
  imports = [ 
    # ./desktop.nix
    # ./packages.nix
    ../../theme
    <nixpkgs/nixos/modules/installer/virtualbox-demo.nix>
  ];

  networking = {
    hostName = "zelos";
    # networkmanager.enable = true;
    # wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };

  users.users.cameron = {
    isNormalUser = true;
    password = "";
    description = "Cameron";
    extraGroups = [ "networkmanager" "wheel" "network" "input" ];
  };

  system.stateVersion = "23.05";
}
