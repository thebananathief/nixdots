{ pkgs, ... }: {
  networking.hostName = "talos";

  imports = [
    ./fileshares.nix
    ./containers
  ];

  # TODO: Need to have disk SMART alerts sent to me over email
  # Also reminders to buy drives


  # TODO: Make sure to use passwd to change the password after logon!
  users.users.cameron = {
    isNormalUser = true;
    description = "Cameron";
    extraGroups = [
      "wheel"
      "podman"
      "allowssh"
    ];
    openssh.authorizedKeys.keyFiles = [
      ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfIygbp1DdDJUCAlUHbrdzu7cnb7T/JTDexJtpMXCIz cameron@phone
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFagsyJw/RCCgkgXtOYKeNF0NH8VABZ0WP+14yeq1/5k laptop
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9BZbMAtMIr0ZZKPwxIDTq7qZMjNVDI1ktg3r+DSCdv desktop
      ''
    ];
  };

  networking = {
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.

    firewall = {
      enable = true;
      allowedTCPPorts = [
        443   # Traefik entrypoint >> overseerr, webtrees, filebrowser, static files, jellyfin
      ];
      # allowedUDPPorts = [ ]; # TODO: gameserver ports?
    };
  };

  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
    xfsprogs
    smartmontools
  ];

  security.pam.enableSSHAgentAuth = true;

  services = {
    openssh = {
      enable = true;
      ports = [ 4733 ];
      openFirewall = true;
      settings = {
        X11Forwarding = false;
        UseDns = false;
        PasswordAuthentication = false;
        kbdInteractiveAuthentication = false; # None of the authentication methods use this I think, so it should never be enabled, yet it defaults to yes in openssh
        PermitRootLogin = "no";
        AllowGroups = [ "allowssh" ];
        LogLevel = "INFO"; # Adjusted so that fail2ban doesn't set it to VERBOSE
      };
      extraConfig = ''
      PermitEmptyPasswords No
      '';
      banner = ''-- WARNING --
        Unauthorized access to this system is forbidden and will be prosecuted by law.
        By accessing this system, you agree that your actions may be monitored if unauthorized usage is suspected.
      '';
    };
    fail2ban = {
      enable = true;
      # TODO: Consider more config https://mynixos.com/nixpkgs/options/services.fail2ban
    };
    cron = {
      enable = true;
      systemCronJobs = [
        "*/15 * * * * curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/${ healthcheck_uptime_uuid }"
      ]
    }
  };

  snapraid = {
    enable = true;
    contentFiles = [
      "/var/snapraid.content"
      "/mnt/parity1/snapraid.content"
      "/mnt/disk1/snapraid.content"
      "/mnt/disk2/snapraid.content"
    ];
    parityFiles = [
      "/mnt/parity1/snapraid.parity"
    ];
    dataDisks = {
      d1 = "/mnt/disk1";
      d2 = "/mnt/disk2";
      d3 = "/mnt/disk3";
    };
    exclude = [
      "*.unrecoverable"
      "/tmp/"
      "/lost+found/"
      "appdata/"
      "downloads/"
      "*.!sync"
      ".AppleDouble"
      "._AppleDouble"
      ".DS_Store"
      "._.DS_Store"
      ".Thumbs.db"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".AppleDB"
      ".nfo"
    ];
  };

  systemd.services.snapraid-sync.serviceConfig.postStart = ''
    curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/f9152e38-9616-427f-92bc-d5b2a0cca5e3 # TODO: OBFUSCATE
  '';

  # TODO: This part should probably be moved to hardware-conf when made
  fileSystems."/mnt/storage" = {
    device = "/mnt/disk*:/mnt/tank/fuse";
    fsType = "fuse.mergerfs";
    options = [
      "defaults"
      "nonempty"
      "allow_other"
      "category.create=epmfs"
      "use_ino"
      "moveonenospc=true"
      "dropcacheonclose=true"
      "minfreespace=50G"
      "fsname=mergerfs"
    ];
  };

  system.stateVersion = "23.05";
}
