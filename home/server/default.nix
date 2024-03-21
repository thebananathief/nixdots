{ pkgs, lib, inputs, ... }: rec {
  imports = [
    ../cameron/zsh.nix
    ../cameron/git.nix
  ];

  home = {
    username = "cameron";
    # home.homeDirectory = "/home/cameron";

    shellAliases = {
      dtail = "docker logs -tf --tail='50'";
      dstop = "docker stop `docker ps -aq`";
      drm = "docker rm `docker ps -aq`";
      # dps = "docker ps --format 'table {{ '{{' }}.Names{{ '}}' }}\\t{{ '{{' }}.Ports{{ '}}' }}\\t{{ '{{' }}.Status{{ '}}' }}'";
      appd = "cd /appdata";
      stor = "cd /mnt/storage";
    };

    packages = with pkgs; [
      lynis
      # at # nonfunctional
      lazydocker
    ];
    
    # Think these might already be handled by config.programs.zsh/neovim (common)
    # sessionVariables = {
    #   EDITOR = "nvim";
    #   SHELL = "zsh";
    # };
  };

  # Install dotfiles repo and link configs
  # home.file."github/dotfiles" = {
  #   recursive = true;
  #   source = builtins.fetchGit {
  #     url = "https://github.com/thebananathief/dotfiles.git";
  #     ref = "main";
  #   };
  #   target = "./github/dotfiles";
  # };

  programs = {
    home-manager.enable = true;

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      icons = false;
      extraOptions = [
        "--all"
        "--color=always"
        "--group"
      ];
    };

    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        manager.show_hidden = true;
      };
    };
  };

  home.stateVersion = "23.05";
}
