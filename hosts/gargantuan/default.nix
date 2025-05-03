{
  pkgs,
  lib,
  config,
  username,
  nixos-hardware,
  ...
}: {
  imports = [
    nixos-hardware.nixosModules.framework-11th-gen-intel
    nixos-hardware.nixosModules.common-hidpi
    ./hardware-configuration.nix
    ../../modules/games.nix
    ../../modules/system-desktop
    ../../modules/tailscale.nix
    ../../modules/security.nix
    ./syncthing.nix
  ];

  home-manager.users.${username} = {
    imports = [
      ../../home/cameron.nix
      ../../home/desktop
    ];
  };

  security.sudo.wheelNeedsPassword = lib.mkForce false;

  networking = {
    hostName = "gargantuan";
    networkmanager.enable = true;
    wireless.enable = false; # Enables wireless support via wpa_supplicant.
    firewall.enable = true;
  };

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIBpTCCAUqgAwIBAgIRAJC8o335E8MFXTXEgBdXNOEwCgYIKoZIzj0EAwIwMDEu
      MCwGA1UEAxMlQ2FkZHkgTG9jYWwgQXV0aG9yaXR5IC0gMjAyNSBFQ0MgUm9vdDAe
      Fw0yNTAzMDEwMDQwMjhaFw0zNTAxMDgwMDQwMjhaMDAxLjAsBgNVBAMTJUNhZGR5
      IExvY2FsIEF1dGhvcml0eSAtIDIwMjUgRUNDIFJvb3QwWTATBgcqhkjOPQIBBggq
      hkjOPQMBBwNCAAQtiJuJKOelFGltNU54EpoRVHwG5mh3tsfb/kvYVBB4PFfU2b6W
      jCrNZmY/Ki6vL+pWTVK8FoaNYdM4lE662ezPo0UwQzAOBgNVHQ8BAf8EBAMCAQYw
      EgYDVR0TAQH/BAgwBgEB/wIBATAdBgNVHQ4EFgQU5bCcwUR4sAMV47TPcqyACJaH
      gpcwCgYIKoZIzj0EAwIDSQAwRgIhAKUa5nSK+LXS2hR0RIaCqmA3LzxBSXGHhlzS
      CHtznPEOAiEAzgaY2D2fi67ibXNB8t1FyL1g8sIFnlUSeF5QMtd7Lsw=
      -----END CERTIFICATE-----
    ''
  ];

  services.mullvad-vpn.enable = true;
  # pkgs.mullvad for CLI only, pkgs.mullvad-vpn for CLI and GUI
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  boot = {
    supportedFilesystems = [
      "ext4"
      "ntfs"
      "fat"
      "exfat"
      "cifs" # mount windows share
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # Prevents a filesystem mount failure from putting us into emergency mode on bootup
  systemd.enableEmergencyMode = false;

  # nix.nixPath = [
  #   "nixos-config=/home/cameron/github/nixdots/flake.nix"
  #   "/nix/var/nix/profiles/per-user/root/channels"
  #   "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  # ];

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
      main_user_password = {neededForUsers = true;};
      email_address = {};
    };
  };

  programs.ssh.startAgent = true;

  users.users.${username} = {
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
  services.pulseaudio.enable = false;
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
