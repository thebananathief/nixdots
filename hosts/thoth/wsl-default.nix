{ nixos-wsl, username, nixpkgs, pkgs, ... }:
{
  imports = [
    nixos-wsl.nixosModules.wsl
    ./wsl.nix
  ];

  networking = {
    hostName = "thoth-wsl";
  };

  nix = {
    nixPath = [
      "nixpkgs=${nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    registry = {
      nixpkgs = {
        flake = nixpkgs;
      };
    };

    package = pkgs.nixFlakes;
  };

  environment.enableAllTerminfo = true;

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

  # home-manager.users.${username} = {
  #   imports = [
  #     ./home.nix
  #   ];
  # };

  system.stateVersion = "22.05";
}