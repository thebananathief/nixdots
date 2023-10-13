{ pkgs, lib, ... }: {
  imports = [
    ./xdg.nix
    ./git.nix
    ./alacritty.nix
    ./zsh.nix
    ./neovim.nix
    ./zathura.nix
    ./fusuma.nix
    ./waybar.nix
    ./hyprland.nix
  ];

  home.username = "cameron";
  # home.homeDirectory = "/home/cameron";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "alacritty";
  };

  home.packages = with pkgs; [
    # Utils
    eza
    ripgrep

    # fonts
    # material-symbols
    # noto-fonts
    # noto-fonts-emoji
    # roboto
    # lexend
    # jost
    #(nerdfonts.override { fonts = [ "jetbrainsmono" "firacode" "firamono" "meslo" "mplus" "robotomono" ]; })
  ];

  # Install dotfiles repo and link configs
  # home.file."github/dotfiles" = {
  #   recursive = true;
  #   source = builtins.fetchGit {
  #     url = "https://github.com/thebananathief/dotfiles.git";
  #     ref = "main";
  #   };
  #   target = "./github/dotfiles";
  # };

  fonts.fontconfig.enable = true;

  # qt = {
  #   enable = true;
  #   platformTheme = "qtct";
  #   style = {
  #     name = "kvantum";
  #     package = pkgs.qt6Packages.qtstyleplugin-kvantum;
  #   };
  # };
  #
  # gtk = {
  #   enable = true;
  #   cursorTheme = {
  #     name = "";
  #     package = pkgs.;
  #     size = 16;
  #   };
  #   font = {
  #     name = "";
  #     package = pkgs.;
  #     size = 8;
  #   };
  #   iconTheme = {
  #     name = "";
  #     package = pkgs.;
  #   };
  #   theme = {
  #     name = "";
  #     package = pkgs.;
  #   };
  #   gtk3.bookmarks = [
  #     "file:///home/cameron/github"
  #   ];
  # };

  programs = {
    home-manager.enable = true;

    eza = {
      enable = true;
      enableAliases = true;
      icons = true;
    };
  };

  home.stateVersion = "23.05";
}
