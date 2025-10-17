{
  pkgs,
  lib,
  config,
  username,
  nixos-hardware,
  nixpkgs,
  ...
}: let
  inherit (config.sops) secrets;
in {
  imports = [
    # nixos-hardware.nixosModules.common-pc
    # nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-cpu-intel
    ./hardware-configuration.nix
    ../../modules/security.nix
    # ../../modules/qubic.nix
  ];

  home-manager.users.${username} = {
    imports = [
      ../../home/cameron.nix
    ];
  };

  networking = {
    hostName = "gridur";
    wireless.enable = false; # Enables wireless support via wpa_supplicant.
    firewall.enable = true;
  };

  boot = {
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

  services.openssh = {
    enable = true;
    ports = [4733];
    settings = {
      X11Forwarding = false;
      UseDns = false;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false; # None of the authentication methods use this I think, so it should never be enabled, yet it defaults to yes in openssh
      PermitRootLogin = "no";
      LogLevel = "INFO"; # Adjusted so that fail2ban doesn't set it to VERBOSE
      AllowUsers = [username]; # Only the main user is allowed in through SSH
    };
    extraConfig = ''
      PermitEmptyPasswords No
    '';
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519";
        type = "ed25519";
      }
    ];
  };

  sops = {
    defaultSopsFile = ../../secrets.yml;
    age = {
      # These should be the paths from (config.services.openssh.hostKeys)
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519"
      ];

      # keyFile technically not used because we're currently
      # using talos's host key to decrypt secrets
      keyFile = "/home/cameron/.config/sops/age/keys.txt";
      generateKey = true;
    };
    # https://github.com/Mic92/sops-nix#set-secret-permissionowner-and-allow-services-to-access-it
    # Permission modes are in octal representation (same as chmod),
    # the digits represent: user|group|owner
    # 7 - full (rwx)
    # 6 - read and write (rw-)
    # 5 - read and execute (r-x)
    # 4 - read only (r--)
    # 3 - write and execute (-wx)
    # 2 - write only (-w-)
    # 1 - execute only (--x)
    # 0 - none (---)
    secrets = {
      main_user_password = {neededForUsers = true;};
    };
  };

  users.users."${username}" = {
    isNormalUser = true;
    hashedPasswordFile = secrets.main_user_password.path;
    description = "Cameron";
    extraGroups = [
      "wheel"
    ];
    # Public keys that are authorized for SSH access
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9r6CO/Xi+wMD65MUBmumv2x9Gi89zj/oD6oD5fD6ai cameron@desktop-jammin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFagsyJw/RCCgkgXtOYKeNF0NH8VABZ0WP+14yeq1/5k laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfIygbp1DdDJUCAlUHbrdzu7cnb7T/JTDexJtpMXCIz cameron@phone"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNVv4iCWxWG2PQlzWAzWqgl7eazAv91EqaYGUmpsyOU deck@UNKNOWN-GALE"
    ];
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools # intel_gpu_top
    librespeed-cli
  ];

  system.stateVersion = "25.05";
}
