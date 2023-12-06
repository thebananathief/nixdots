{ pkgs,
  lib,
  sops-nix,
  config,
  nixos-hardware,
  ...
}: {
  imports = [ 
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-cpu-intel
    ./hardware-configuration.nix
    ../gargantuan/packages.nix
    # ../../modules/games.nix
    ../../modules/desktop
    # sops-nix.nixosModules.sops
  ];

  networking = {
    hostName = "thoth";
    networkmanager.enable = true;
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };
  
  # sops = {
  #   defaultSopsFile = ../../secrets.yml;
  #   age = {
  #     sshKeyPaths = [
  #       "/etc/ssh/ssh_host_ed25519"
  #     ];
      
  #     keyFile = "/var/lib/sops-nix/key.txt";
  #     generateKey = true;
  #   };
  #   secrets = {
  #     main_user_password = { neededForUsers = true; };
  #     email_address = {};
  #     sshPub_phone = {};
  #     ssh_github = {};
  #   };
  # };

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

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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
  };
  
  # https://nixos.wiki/wiki/Nvidia
  # Load nvidia driver for Xorg and Wayland
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
  };

  system.stateVersion = "23.05";
}

