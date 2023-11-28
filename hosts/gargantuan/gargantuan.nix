{ pkgs, lib, ... }: {
  imports = [ 
    ./hardware-configuration.nix
    ./packages.nix
    # ../../modules/games.nix
    ../../modules/desktop
    ../../modules/theme
  ];

  networking = {
    hostName = "gargantuan";
    networkmanager.enable = true;
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };

  programs.ssh.startAgent = true;

  # TODO: Make sure to use passwd to change the password after logon!
  users.users.cameron = {
    isNormalUser = true;
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
    # jack.enable = true; # only used for MIDI stuff i think
  };
  
  # Fingerprint reader daemon
  services.fprintd.enable = true;
  # security.pam.services.login.fprintAuth = true;
  # security.pam.services.xscreensaver.fprintAuth = true;


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

