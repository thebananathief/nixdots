{ pkgs, lib, inputs, ... }: rec {
  imports = [
  ];

  home.username = "cameron";
  # home.homeDirectory = "/home/cameron";

  systemd.user.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "zsh";
  };

  home.sessionVariables = systemd.user.sessionVariables;

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
      enableAliases = true;
      icons = false;
      extraOptions = [
        "--all"
        "--color=always"
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
