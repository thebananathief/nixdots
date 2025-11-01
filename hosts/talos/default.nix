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
    ./storage.nix
    ./fileshares.nix
    ./services
    ./monitoring.nix
    ./backup.nix
    ./options.nix
    ../../modules/tailscale.nix
    ../../modules/security.nix
  ];

  home-manager.users.${username} = {
    imports = [
      ../../home/cameron.nix
    ];
  };

  # Used for binding servers to only these interfaces explicitly
  tailscaleInterfaces = [
    "100.64.252.67"
    "fd7a:115c:a1e0::9f40:fc43"
  ];
  networking = {
    hostName = "talos";
    publicDomain = "talos.host";
    domain = "home.arpa";
    # fqdn = "talos.host";
    wireless.enable = false; # Enables wireless support via wpa_supplicant.
    firewall.enable = true;
  };

  # nix.nixPath = [
  #   "nixos-config=/home/cameron/github/nixdots/flake.nix"
  #   "/nix/var/nix/profiles/per-user/root/channels"
  #   # "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  #   "nixpkgs=${nixpkgs.outPath}"
  #   # "/home/cameron/.nix-defexpr/channels"
  # ];

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
      email_address = {};
      gmail_password = {};
      discord_webhook_id = {}; # used in jellyseerr's notification config, but not declarative yet
      discord_webhook_token = {};
      domain = {};
    };
  };

  users.users."${username}" = {
    isNormalUser = true;
    hashedPasswordFile = secrets.main_user_password.path;
    description = "Cameron";
    extraGroups = [
      "wheel"
      # "mediaserver" # needed for /tv, /movies, /books
      # "minecraft" # needed for minecraft data dir
      # config.virtualisation.oci-containers.backend
    ];
    # Public keys that are authorized for SSH access
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9r6CO/Xi+wMD65MUBmumv2x9Gi89zj/oD6oD5fD6ai cameron@desktop-jammin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFagsyJw/RCCgkgXtOYKeNF0NH8VABZ0WP+14yeq1/5k laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfIygbp1DdDJUCAlUHbrdzu7cnb7T/JTDexJtpMXCIz cameron@phone"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNVv4iCWxWG2PQlzWAzWqgl7eazAv91EqaYGUmpsyOU deck@UNKNOWN-GALE"
    ];
  };
  security.pam = {
    sshAgentAuth.enable = true;
    services.sudo.sshAgentAuth = true;
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools # intel_gpu_top
    librespeed-cli
  ];

  sops.secrets.healthcheck_uptime_uuid = {};
  sops.secrets.healthcheck_external_access_uuid = {};
  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "@reboot root ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$(< ${secrets.healthcheck_uptime_uuid.path})"
        "*/15 * * * * root ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$(< ${secrets.healthcheck_uptime_uuid.path})"
        # Healthcheck to make sure TALOS is externally accessible
        # "*/15 * * * * root ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$(< ${secrets.healthcheck_external_access_uuid.path})"
      ];
    };
    fail2ban = {
      enable = true;
      # TODO: Consider more config https://mynixos.com/nixpkgs/options/services.fail2ban
    };
    tailscale = {
      useRoutingFeatures = "server";
      openFirewall = false; # opens port 41641
      # extraUpFlags = [
      #   # "--advertise-routes=192.168.0.0/24"
      #   # "--advertise-exit-node"
      # ];
    };
  };

  system.stateVersion = "23.11";
}
