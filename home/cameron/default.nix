{ pkgs, builtins, ... }: {
  imports = [
    ./xdg.nix
    ./git.nix
    ./alacritty.nix
    ./zsh.nix
    ./neovim.nix
    ./zathura.nix
    ./fusuma.nix
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

  # Install dotfiles repo and link configs
  home.file."github/dotfiles" = {
    recursive = true;
    source = builtins.fetchGit {
      url = "ssh://git@github.com:thebananathief/dotfiles.git";
      rev = "latest";
      ref = "main";
    };
    target = "github/dotfiles";
  };

  home.stateVersion = "23.05";
}
