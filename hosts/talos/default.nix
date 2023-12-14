{ 
  pkgs, 
  nixos-hardware,
  lib, 
  sops-nix, 
  config, 
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
        4733
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
      KbdInteractiveAuthentication = false; # None of the authentication methods use this I think, so it should never be enabled, yet it defaults to yes in openssh
      PermitRootLogin = "no";
      # AllowGroups = [ "allowssh" ];
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
      keyFile = "/home/cameron/.config/sops/age/keys.txt";
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
      tailscale_authkey = {};
      ssh_port = {};
      discord_webhook_id = {};
      discord_webhook_token = {};
      cloudflare_api = {};
      healthcheck_snapraid_uuid = {};
      healthcheck_uptime_uuid = {};
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
      "docker"
      "allowssh" # allows this user to login via ssh
    ];
    # Public keys that are authorized for SSH access
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9BZbMAtMIr0ZZKPwxIDTq7qZMjNVDI1ktg3r+DSCdv desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFagsyJw/RCCgkgXtOYKeNF0NH8VABZ0WP+14yeq1/5k laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfIygbp1DdDJUCAlUHbrdzu7cnb7T/JTDexJtpMXCIz cameron@phone"
    ];
  };

  environment.systemPackages = with pkgs; [
    lazydocker
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
        # $__file{${config.sops.secrets.healthcheck_uptime_uuid.path}}
        # Healthcheck to ensure TALOS is online
        "*/15 * * * * curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/855c9b0c-0630-4d21-8f11-14003b34628e"
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
