{ nixos-wsl, ... }:
{
  imports = [
    nixos-wsl.nixosModules.wsl
    ./wsl.nix
  ];

  time.timeZone = "America/New_York";
  networking.hostName = "${hostname}";

  environment.enableAllTerminfo = true;
  security.sudo.wheelNeedsPassword = false;

  # FIXME: uncomment the next line to enable SSH
  # services.openssh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    # FIXME: change your shell here if you don't want fish
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      # FIXME: uncomment the next line if you want to run docker without sudo
      # "docker"
    ];
    # FIXME: add your own hashed password
    # hashedPassword = "";
    # FIXME: add your own ssh public key
    # openssh.authorizedKeys.keys = [
    #   "ssh-rsa ..."
    # ];
  };

  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "22.05";



  nix = {
    settings = {
      trusted-users = [username];
      # FIXME: use your access tokens from secrets.json here to be able to clone private repos on GitHub and GitLab
      # access-tokens = [
      #   "github.com=${secrets.github_token}"
      #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
      # ];

      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixFlakes;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}