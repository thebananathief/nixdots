{ pkgs, lib, sops-nix, config, ... }: {
  imports = [ 
    ./hardware-configuration.nix
    ./packages.nix
    # ../../modules/games.nix
    ../../modules/desktop
    sops-nix.nixosModules.sops
  ];

  networking = {
    hostName = "gargantuan";
    networkmanager.enable = true;
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };

  # TODO: REMOVE THIS
  services.openssh = {
    enable = true;
    hostKeys = [
      {
        comment = "gargantuan";
        path = "/etc/ssh/ssh_host_ed25519";
        rounds = 100;
        type = "ed25519";
      }
    ];
  };
  
  sops = {
    defaultSopsFile = ../../secrets/misc.yml;
    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519"
      ];
      
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      main_user_password = { neededForUsers = true; };
      email_address = {};
      sshPub_phone = {};
      sshPub_laptop = {};
      sshPub_desktop = {};
      ssh_github = {};
    };
  };

  programs.ssh.startAgent = true;

  # TODO: Make sure to use passwd to change the password after logon!
  users.users.cameron = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.main_user_password.path;
    description = "Cameron";
    extraGroups = [
      "networkmanager"
      "network"
      "wheel"
      "input"
    ];
  };
  
  # enable location service
  # location.provider = "geoclue2";

  hardware.bluetooth.enable = true;

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
  
  # Fingerprint reader daemon
  services.fprintd.enable = true;
  security.pam.services.login.unixAuth = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.login.nodelay = true;

  # Power saving profile
  # Consider:
  # upower
  services.tlp = {
    enable = true;
    settings = {
      PCIE_ASPM_ON_BAT = "powersupersave";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
      NMI_WATCHDOG = 0;
    };
  };
  # This part is required if the above is enabled
  services.power-profiles-daemon.enable = lib.mkForce false;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  system.stateVersion = "23.05";
}

