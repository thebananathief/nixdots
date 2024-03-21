{ pkgs,
  lib,
  sops-nix,
  config,
  nixos-hardware,
  ...
}: {
  imports = [ 
    # nixos-hardware.nixosModules.common-pc
    # nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-cpu-intel
    ./hardware-configuration.nix
    ../gargantuan/packages.nix
    ../gargantuan/network-mount.nix
    ../../modules/desktop
#     ../../modules/desktop/plasma.nix
    ../../modules/games.nix
    sops-nix.nixosModules.sops
  ];

  networking = {
    hostName = "thoth";
    networkmanager.enable = true;
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };
  
  # Was causing errors for me earlier, so I added this line
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

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
      # ssh_github = {};
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

  environment.systemPackages = with pkgs; [
    libva
  ];

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
#     enableSSHSupport = true;
    enableBrowserSocket = true;
  };
  
  # https://nixos.wiki/wiki/Nvidia
  # Load nvidia driver for Xorg and Wayland
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # Defaults from article above - all these are experimental
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;
    
    # stable or beta should work for most modern cards
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime.offload.enable = false;
  };

  system.stateVersion = "23.11";
}

