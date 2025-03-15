{
  pkgs,
  lib,
  username,
  config,
  nixos-hardware,
  ...
}: let
  inherit (config.sops) secrets;
in {
  imports = [
    # nixos-hardware.nixosModules.common-pc
    # nixos-hardware.nixosModules.common-pc-ssd
    # nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-cpu-intel
    ./hardware-configuration.nix
    ../../modules/nvidia.nix
    ../../modules/desktop
    ../../modules/tailscale.nix
    ../../modules/security.nix
  ];

  home-manager.users.${username} = {
    imports = [
      ../../home/cameron.nix
      ../../home/desktop
    ];
  };

  boot.supportedFilesystems = [
    "ext4"
    # "btrfs"
    "xfs"
    "ntfs"
    "fat"
    # "vfat"
    "exfat"
    "cifs" # mount windows share
  ];

  networking = {
    hostName = "thoth";
    networkmanager.enable = true;
    wireless.enable = false; # Enables wireless support via wpa_supplicant.
    firewall.enable = true;
  };

  services.mullvad-vpn.enable = true;
  # pkgs.mullvad for CLI only, pkgs.mullvad-vpn for CLI and GUI
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # nix.nixPath = [
  #   "nixos-config=/home/cameron/github/nixdots/flake.nix"
  #   "/nix/var/nix/profiles/per-user/root/channels"
  #   "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  # ];

  # Was causing errors for me earlier, so I added this line
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Helps with build times (ram filesystem)
  boot.tmp.useTmpfs = true;
  # boot.tmp.tmpfsSize = "50%";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.package = pkgs.bluez;

  sops = {
    defaultSopsFile = ../../secrets.yml;
    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519"
      ];
    };
    secrets = {
      main_user_password = {neededForUsers = true;};
    };
  };

  programs.ssh.startAgent = true;

  users.users.${username} = {
    isNormalUser = true;
    hashedPasswordFile = secrets.main_user_password.path;
    description = "Cameron";
    extraGroups = [
      "networkmanager"
      "network"
      "wheel"
      "input"
    ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #   programs.mtr.enable = true;
  #   programs.gnupg.agent = {
  #     enable = true;
  # #     enableSSHSupport = true;
  #     enableBrowserSocket = true;
  #   };

  system.stateVersion = "23.11";
}
