{ pkgs, nixos-hardware, lib, sops-nix, config, username, ... }: {
  imports = [
    nixos-hardware.nixosModules.common-cpu-intel
    sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    ./restic.nix
  ];

  networking = {
    hostName = "icebox";
    wireless.enable = false; # Enables wireless support via wpa_supplicant.
    firewall.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 30;
    efi.canTouchEfiVariables = true;
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      X11Forwarding = false;
      UseDns = false;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false; # None of the authentication methods use this I think, so it should never be enabled, yet it defaults to yes in openssh
      PermitRootLogin = "no";
      LogLevel = "INFO"; # Adjusted so that fail2ban doesn't set it to VERBOSE
      AllowUsers = [
        username
        "restic"
      ];
    };
    extraConfig = ''
      PermitEmptyPasswords No
    '';
    banner = ''
-- WARNING --
Unauthorized access to this system is forbidden and will be prosecuted by law.
By accessing this system, you agree that your actions may be monitored if unauthorized usage is suspected.
    '';
  };

  sops = {
    defaultSopsFile = ../../secrets.yml;
    # These should be the paths from (config.services.openssh.hostKeys)
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519" ];
    secrets = {
      # main_user_password = { neededForUsers = true; };
      healthcheck_icebox_uptime = {};
    };
  };

  users.users."${username}" = {
    isNormalUser = true;
    description = "Cameron";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9r6CO/Xi+wMD65MUBmumv2x9Gi89zj/oD6oD5fD6ai cameron@desktop-jammin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFagsyJw/RCCgkgXtOYKeNF0NH8VABZ0WP+14yeq1/5k laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfIygbp1DdDJUCAlUHbrdzu7cnb7T/JTDexJtpMXCIz cameron@phone"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNVv4iCWxWG2PQlzWAzWqgl7eazAv91EqaYGUmpsyOU deck@UNKNOWN-GALE"
    ];
  };
  
  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "@reboot root ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$(< ${config.sops.secrets.healthcheck_icebox_uptime.path})"
        "*/15 * * * * root ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$(< ${config.sops.secrets.healthcheck_icebox_uptime.path})"
      ];
    };
    fail2ban = {
      enable = true;
      # TODO: Consider more config https://mynixos.com/nixpkgs/options/services.fail2ban
    };
    tailscale = {
      useRoutingFeatures = "server";
      # authKeyFile = config.sops.secrets.tailscale_authkey.path;
      # openFirewall = true; # opens port 41641
    };
  };

  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "fat"
    "exfat"
  ];

  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];



  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
