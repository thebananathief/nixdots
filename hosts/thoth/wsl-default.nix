{
  config,
  lib,
  pkgs,
  nixos-wsl,
  username,
  nixpkgs,
  ...
}: let
  inherit (config.sops) secrets;
  
  plandex = pkgs.plandex.overrideAttrs (oldAttrs: rec {
    inherit (oldAttrs) pname;
    version = "2.2.1";
    src = pkgs.fetchFromGitHub {
      owner = "plandex-ai";
      repo = "plandex";
      rev = "cli/v${version}";
      hash = "sha256-xtK/6eK3Xm7vGgADsVzFOKaFI7E2uYFu/E/NiyeLWhk=";
    };
    vendorHash = "sha256-K6KzOxiXZY9cuCh6mTYZ/QNh+yV4y5cQk2xjL3YMLQo=";
  });
in {
  imports = [
    nixos-wsl.nixosModules.wsl
  ];

  environment.systemPackages = with pkgs; [
    plandex
  ];

  home-manager.users.${username} = {
    imports = [
      ../../home/cameron.nix
      {
        # Keep LF line endings on WSL, CRLF when checked out on Windows
        programs.git.settings.core.autocrlf = "input";
      }
    ];
  };

  networking = {
    hostName = "thoth-wsl";
    firewall.enable = false;
  };

  # nix.nixPath = [
  #   "nixpkgs=${nixpkgs.outPath}"
  #   "nixos-config=/home/cameron/nixdots/flake.nix"
  #   "/nix/var/nix/profiles/per-user/root/channels"
  # ];

  security.sudo.wheelNeedsPassword = false;
  sops = {
    defaultSopsFile = ../../secrets.yml;
    # This should be the private key(s) you want to use to decrypt secrets.yml
    age.sshKeyPaths = ["/home/cameron/.ssh/id_ed25519"];
    secrets.main_user_password = {neededForUsers = true;};
  };

  users.users.${username} = {
    isNormalUser = true;
    hashedPasswordFile = secrets.main_user_password.path;
    description = "Cameron";
    extraGroups = [
      "wheel"
    ];
  };

  # This is needed for VSCode-Server to work
  programs.nix-ld = {
    enable = true;
  };

  wsl = {
    enable = true;
    wslConf.automount.enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.enable = true;
    wslConf.interop.appendWindowsPath = true;
    wslConf.network.generateHosts = true;
    wslConf.network.generateResolvConf = false;
    defaultUser = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = false;
  };
  networking.nameservers = [
    "192.168.0.1"
    "1.1.1.1"
    "8.8.8.8"
  ];

  # virtualisation.docker = {
  #   enable = true;
  #   enableOnBoot = true;
  #   autoPrune.enable = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
