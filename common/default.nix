{ lib, pkgs, ... }: {
  imports = [
    ./shell.nix
    ./security.nix
    ./tailscale.nix
  ];

  # These nix configs are only for the system, not the flake
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = pkgs.lib.mkDefault "--delete-older-than 7d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
      builders-use-substitutes = true;
      substituters = lib.mkBefore [
        "https://cache.nixos.org/?priority=5"
        "https://nix-community.cachix.org?priority=10"
        "https://anyrun.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };
  };

  # Set your time zone.
#  services.ntp.enable = true;
  time.timeZone = "America/New_York";

  console.keyMap = "us";
  console.font = "Lat2-Terminus16";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  environment.systemPackages = with pkgs; [
    git wget curl unzip killall
    ethtool lm_sensors pciutils
    tmux neofetch bottom
    tailspin bat dua tree
    dos2unix tldr just
    age sops

    # universal-ctags
    # cut
    # intel-gpu-tools
    # dnsutils
    # net-tools
    # iftop
    # iotop
    # fio
    # hddtemp
    # nmap
  ];

  boot.supportedFilesystems = [
    "ext4"
    # "btrfs"
    "xfs"
    #"zfs"
    "ntfs"
    "fat"
    # "vfat"
    "exfat"
    # "cifs" # mount windows share
  ];
}

