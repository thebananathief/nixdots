{ pkgs, ... }: {
  imports = [
    ../modules/zsh.nix
    ../modules/neovim.nix
    ../modules/security.nix
    ../modules/tailscale.nix
    # ./audio.nix
    # ./autorandr.nix
    # ./devlopment.nix
    # ./containers.nix
    # ./essentials.nix
    # ./fonts.nix
    # ./gestures
    # ./kernel.nix
    # ./network-shares.nix
    # ./programs.nix
    # ./plymouth.nix
    # ./ssh.nix
    # ./sudo.nix
    # ./tailscale.nix
    # ./users
    # ./xserver.nix
  ];

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
      #substituters = lib.mkBefore [
        #"https://cache.jrnet.win/main?priority=1"
        #"https://nix-community.cachix.org?priority=25"
        #"https://jrmurr.cachix.org?priority=2"
        #"https://cache.nixos.org/?priority=20"
      #];
      #trusted-public-keys = [
        #"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        #"jrmurr.cachix.org-1:nE2/Ms3YbTPe8SrFOWsHfcNAuJtJtz9UCoohiSn6Elg="
        #"main:doBjjo8BjzYQ+YJG6YNQ/7RqgVsgYWL+1Pv86p0/7fk="
      #];
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/180175
  #systemd.services.NetworkManager-wait-online.enable = false;
}

