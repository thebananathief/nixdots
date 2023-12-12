{ 
  pkgs, 
  nixos-hardware,
  ...
}: {
  imports = [
    # nixos-hardware.nixosModules.common-pc
    # nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-cpu-intel
    ./hardware-configuration.nix
    ./fileshares.nix
    ./disks.nix
    ./containers
    sops-nix.nixosModules.sops
  ];

  networking = {
    hostName = "talos";
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.

    firewall = {
      enable = true;
      allowedTCPPorts = [
        443   # Traefik entrypoint >> overseerr, webtrees, filebrowser, static files, jellyfin
      ];
      # allowedUDPPorts = [ ]; # TODO: gameserver ports?
    };
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 30; # Helpful to prevent running out of space on /boot (gc handles it already tho)
    # consoleMode = "max";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  
  services.openssh = {
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

  sops = {
    defaultSopsFile = ../../secrets.yml;
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
      ssh_github = {};
    };
  };

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

  security.pam.enableSSHAgentAuth = true;

  services = {
    fail2ban = {
      enable = true;
      # TODO: Consider more config https://mynixos.com/nixpkgs/options/services.fail2ban
    };
    cron = {
      enable = true;
      systemCronJobs = [
        # Healthcheck to ensure TALOS is online
        "*/15 * * * * curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/${ healthcheck_uptime_uuid }"
      ];
    };
    tailscale = {
      useRoutingFeatures = "server";
      authKeyFile = "/run/secrets/tailscale_authkey";
      extraUpFlags = [
        "--advertise-routes=192.168.0.0/24"
        # "--advertise-exit-node"
      ];
    };
  };

  system.stateVersion = "23.11";
}
