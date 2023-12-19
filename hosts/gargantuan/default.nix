{
  pkgs,
  lib,
  sops-nix,
  config,
  nixos-hardware,
  ...
}: {
  imports = [
    nixos-hardware.nixosModules.framework-11th-gen-intel
    ./hardware-configuration.nix
    ./packages.nix
    # ./network-mount.nix
    # ../../modules/games.nix
    # ./precommit.nix
    ../../modules/desktop
    sops-nix.nixosModules.sops
  ];

  networking = {
    hostName = "gargantuan";
    networkmanager.enable = true;
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };

  # Was causing errors for me earlier, so I added this line
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  sops = {
    defaultSopsFile = ../../secrets.yml;
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
      ssh_github = {};
      smb-secrets = {};
    };
  };

  programs.ssh.startAgent = true;

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
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.package = pkgs.bluez;

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

  # Allow pam login via fingerprint reader
  security.pam.services.login.fprintAuth = true;
  security.pam.services.login.nodelay = true; # may be unsafe because of no delays for brute-force attacks
  # and unix
  security.pam.services.login.unixAuth = true;

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
  # Intel should use TLP, AMD should use power-profiles-daemon
  services.power-profiles-daemon.enable = lib.mkForce false;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  system.stateVersion = "23.05";
}
