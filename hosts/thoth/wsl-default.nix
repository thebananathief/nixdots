{ config, lib, pkgs, nixos-wsl, username, nixpkgs, ... }:
let
  inherit (config.sops) secrets;
in {
  imports = [
    nixos-wsl.nixosModules.wsl
  ];

  networking = {
    hostName = "thoth-wsl";
    firewall.enable = false;
  };

  nix = {
    nixPath = [
      "nixpkgs=${nixpkgs.outPath}"
      "nixos-config=/home/cameron/nixdots/flake.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    # registry = {
    #   nixpkgs = {
    #     flake = nixpkgs;
    #   };
    # };

    # package = pkgs.nixFlakes;
  };

  # environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;
  sops = {
    defaultSopsFile = ../../secrets.yml;
    # This should be the private key(s) you want to use to decrypt secrets.yml
    age.sshKeyPaths = [ "/root/.ssh/id_ed25519" ];
    secrets.main_user_password = { neededForUsers = true; };
  };
  
  users.users.${username} = {
    isNormalUser = true;
    hashedPasswordFile = secrets.main_user_password.path;
    description = "Cameron";
    extraGroups = [
      "wheel"
    ];
  };

  home-manager.users.${username} = {
    imports = [ 
      ../../home/server.nix
      ../../home/zsh.nix
      ../../home/git.nix
      {
        # Keep LF line endings on WSL, CRLF when checked out on Windows
        programs.git.extraConfig.core.autocrlf = "input";
      }
    ];
  };

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = true;
    wslConf.network.generateHosts = true;
    wslConf.network.generateResolvConf = true;
    # wslConf.user = "${username}";
    defaultUser = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = false;
  };

  # virtualisation.docker = {
  #   enable = true;
  #   enableOnBoot = true;
  #   autoPrune.enable = true;
  # };
  
  # FIXME: uncomment the next block to make vscode running in Windows "just work" with NixOS on WSL
  # solution adapted from: https://github.com/K900/vscode-remote-workaround
  # more information: https://github.com/nix-community/NixOS-WSL/issues/238 and https://github.com/nix-community/NixOS-WSL/issues/294
  # systemd.user = {
  #   paths.vscode-remote-workaround = {
  #     wantedBy = ["default.target"];
  #     pathConfig.PathChanged = "%h/.vscode-server/bin";
  #   };
  #   services.vscode-remote-workaround.script = ''
  #     for i in ~/.vscode-server/bin/*; do
  #       if [ -e $i/node ]; then
  #         echo "Fixing vscode-server in $i..."
  #         ln -sf ${pkgs.nodejs_18}/bin/node $i/node
  #       fi
  #     done
  #   '';
  # };
  
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
