{ pkgs, lib, sops-nix, config, nixos-hardware, ... }: {
  imports = [
    nixos-hardware.nixosModules.framework-11th-gen-intel
    nixos-hardware.nixosModules.common-hidpi
    sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    ../../modules/packages.nix
    # ../../modules/network-mount.nix
    ../../modules/games.nix
    # ../../modules/test-containers.nix
    ../../modules/desktop
    ../../modules/tailscale.nix
  ];

  boot.supportedFilesystems = [
    "ext4"
    # "btrfs"
    # "xfs"
    "ntfs"
    "fat"
    # "vfat"
    "exfat"
    "cifs" # mount windows share
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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # Power saving profile
  # Consider upower instead
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  system.stateVersion = "23.05";
}
