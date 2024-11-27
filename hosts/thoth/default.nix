{ pkgs, lib, sops-nix, config, nixos-hardware, ... }: 
let 
in {
  imports = [ 
    # nixos-hardware.nixosModules.common-pc
    # nixos-hardware.nixosModules.common-pc-ssd
    # nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-cpu-intel
    sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    ../../modules/nvidia.nix
    ../../modules/packages.nix
    ../../modules/desktop
    # ../../modules/network-mount.nix
    # ../../modules/ai.nix
    # ../../modules/monero.nix
    ../../modules/nifi.nix
    ../../modules/tailscale.nix
  ];
  
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
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };
  
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
      keyFile = "/home/cameron/.config/sops/age/keys.txt";
      generateKey = true;
    };
    # secrets = {
      # main_user_password = { neededForUsers = true; };
      # email_address = {};
    # };
  };

  programs.ssh.startAgent = true;

  users.users.cameron = {
    isNormalUser = true;
    # hashedPasswordFile = config.sops.secrets.main_user_password.path;
    description = "Cameron";
    extraGroups = [
      "networkmanager"
      "network"
      "wheel"
      "input"
    ];
  };

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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

