{ lib, pkgs, ... }: {
  imports = [
    ./myOptions.nix
    ./shell.nix
    ./security.nix
    ./tailscale.nix
  ];

  # These nix configs are only for the system, not the flake
  nix = {
    nixPath = [
      "nixos-config=/home/cameron/github/nixdots/flake.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      # "/home/cameron/.nix-defexpr/channels"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
      builders-use-substitutes = true;
      trusted-substituters = lib.mkBefore [
        "https://cache.nixos.org/?priority=5"
        "https://nix-community.cachix.org?priority=10"
        # "https://ai.cachix.org"
        # "https://anyrun.cachix.org"
        "https://cosmic.cachix.org"
        # "https://pre-commit-hooks.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
        # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        # "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      ];
    };
  };

  # Set your time zone.
#  services.ntp.enable = true;
  time.timeZone = "America/New_York";

  console.keyMap = "us";

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
  # BASIC utils that should be on every system running this flake
    git wget curl unzip killall
    nettools dig lsof
    ethtool lm_sensors pciutils
    zellij neofetch bottom
    bat dua tree jq duf
    dos2unix tldr just
    age sops
    nurl

    # intel-gpu-tools
    # dnsutils
    # iftop
    # iotop
    # fio
    # hddtemp
    # nmap
  ];
}
