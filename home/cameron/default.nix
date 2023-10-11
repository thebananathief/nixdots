{ pkgs, ... }: { 
  imports = [
    ./alacritty.nix
    ./neovim.nix
    ./zsh.nix
    ./git.nix
    ./zathura.nix
    ./xdg.nix
  ];

  home.username = "cameron";
  # home.homeDirectory = "/home/cameron";

  # home.shellAliases = {
  #   edit = "$EDITOR";
  #   e = "$EDITOR";
  #   nic = "edit ~/github/nixdots";
  #   vic = "edit ~/github/dotfiles/.config/nvim";
  # };
  
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

  home.stateVersion = "23.05";
}
