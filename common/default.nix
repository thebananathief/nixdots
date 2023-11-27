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
      options = "--delete-older-than 7d";
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
"https://hyprland.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
              ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
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
    git
    wget
    curl
    htop
    unzip
    tmux
    tree
    killall
    neofetch
    ethtool
    just
#    universal-ctags
    dos2unix
    tldr
#    dua
    #cut
  ];
}

