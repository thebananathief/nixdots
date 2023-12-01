{ pkgs, ... }: {
  networking.hostName = "talos";

  imports = [
    ./fileshares.nix
    ./containers
    <sops-nix/modules/sops>
  ];
  
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
    hostKeys = [
      {
        comment = "talos";
        path = "/etc/ssh/ssh_host_ed25519";
        rounds = 100;
        type = "ed25519";
      }
    ];
  };

  sops = {
    defaultSopsFile = ../../secrets/misc.yml;
    age = {
      # These should be the paths from (config.services.openssh.hostKeys)
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519"
      ];

      # keyFile technically not used because we're currently
      # using talos's host key to decrypt secrets
      # keyFile = "/home/cameron/.config/sops/age/keys.txt";
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      main_domain = {};
      main_username = {};
      main_user_password = {};
      email_address = {};
      gmail_password = {};
      influx_db_token = {};
      influx_db_pass = {};
      mysql_password = {};
      postgres_password = {};
      webtrees_password = {};
      nordvpn_user = {};
      nordvpn_pass = {};
      tailscale_authkey = {};
      ssh_port = {};
      discord_webhook_id = {};
      discord_webhook_token = {};
      cloudflare_api = {};
      healthcheck_snapraid_uuid = {};
      healthcheck_uptime_uuid = {};
      sshPub_phone = {};
      sshPub_laptop = {};
      sshPub_desktop = {};
      ssh_github = {};
    };
  };

  # TODO: Need to have disk SMART alerts sent to me over email
  # Also reminders to buy drives


  # TODO: Make sure to use passwd to change the password after logon!
  users.users.cameron = {
    isNormalUser = true;
    description = "Cameron";
    extraGroups = [
      "wheel"
      "podman"
      "allowssh" # allows this user to login via ssh
    ];
    # Public keys that are authorized for SSH access
    openssh.authorizedKeys.keyFiles = [
      ''
        /run/secrets/sshPub_desktop
        /run/secrets/sshPub_laptop
        /run/secrets/sshPub_phone
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
    fail2ban = {
      enable = true;
      # TODO: Consider more config https://mynixos.com/nixpkgs/options/services.fail2ban
    };
    cron = {
      enable = true;
      systemCronJobs = [
        "*/15 * * * * curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/${ healthcheck_uptime_uuid }"
      ]
    };
    tailscale = {
      useRoutingFeatures = "server";
      authKeyFile = "/run/secrets/tailscale_authkey";
      extraUpFlags = [
        "--advertise-routes=192.168.0.0/24"
        "--advertise-exit-node"
      ];
    };
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

  # This is my attempt to add a healthcheck ping to the snapraid-sync
  # service that services.snapraid creates.
  systemd.services.snapraid-sync.serviceConfig.postStart = ''
    curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/${ healthcheck_snapraid_uuid }
  '';

  # Make sure the device defines the mountpoints you want to merge
  # (anything starting with "disk" in /mnt/)
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
