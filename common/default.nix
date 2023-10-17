{ lib, pkgs, ... }: {
  imports =
    [ ./zsh.nix ./neovim.nix ./security.nix ./tailscale.nix ];

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
      substituters = lib.mkBefore [
        "https://cache.nixos.org/?priority=5"
        "https://nix-community.cachix.org?priority=10"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    unzip
    tmux
    tree
    killall
  ];
}

