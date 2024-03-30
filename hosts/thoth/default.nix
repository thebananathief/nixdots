{ pkgs, lib, sops-nix, config, nixos-hardware, callPackage, javaPackages, ... }: {
  imports = [ 
    # nixos-hardware.nixosModules.common-pc
    # nixos-hardware.nixosModules.common-pc-ssd
    # nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-cpu-intel
    ./hardware-configuration.nix
    ../gargantuan/packages.nix
    # ../gargantuan/network-mount.nix
    ../../modules/desktop
    sops-nix.nixosModules.sops
  ];
  
  services = {
    minecraft-server = {
      enable = true;
      eula = true;
      package = let
        neoforgeServer = callPackage ../../packages/minecraft-neoforge/derivation.nix {
          sha256 = "09pmvwvvic6wxrwjlcvwzgk9yf08wzvn9k23i3c7k44rrfyiaaxb";
          url = "https://maven.neoforged.net/releases/net/neoforged/forge/1.20.1-47.1.84/forge-1.20.1-47.1.84-installer.jar";
          version = "1.20.1-47.1.84";
          getJavaVersion = v: (builtins.getAttr "openjdk${toString v}" javaPackages.compiler).headless;
          jre_headless = getJavaVersion 17; # versions <= 1.6 will default to 8
        };
      in neoforgeServer.packages."neoforge-1.20.1-47.1.84";
      # openFirewall = true;
      # declarative = true;
      # serverProperties = {
      #   motd = "The UPS Store";
      #   server-port = 25565;
      #   difficulty = 3;
      #   gamemode = 0;
      #   max-players = 24;
      #   enable-rcon = true;
      #   "rcon.port" = 25575;
      #   "rcon.password" = "stupidpassword";
      # };
    };
  };

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
    # vulkan-loader
    # vulkan-validation-layers
    # vulkan-tools
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
#   programs.mtr.enable = true;
#   programs.gnupg.agent = {
#     enable = true;
# #     enableSSHSupport = true;
#     enableBrowserSocket = true;
#   };

  # services.ollama = {
  #   enable = true;
  #   listenAddress = "127.0.0.1:11434";
  #   acceleration = "cuda";
  # };
  
  # https://nixos.wiki/wiki/Nvidia
  # Load nvidia driver for Xorg and Wayland
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # stable or beta should work for most modern cards
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # Enable modesetting for Wayland compositors (hyprland)
    modesetting.enable = true;
    
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;
    
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    
    # Use the open source version of the kernel module (for driver 515.43.04+)
    open = false;
    
    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;
  };
  
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  system.stateVersion = "23.11";
}

