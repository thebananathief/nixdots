{ pkgs, lib, ... }: {
  imports = [
    ./xdg.nix
    # ./dconf.nix
    ./git.nix
    ./alacritty.nix
    ./zsh.nix
    # ./neovim.nix
    ./zathura.nix
    ./fusuma.nix
    ./rofi.nix
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

  qt = {
    enable = true;
    platformTheme = "qtct";
    style = {
      name = "kvantum";
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Catppuccin-Mocha-Mauve";
      package = pkgs.catppuccin-cursors.mochaMauve;
      size = 24;
    };
    font = {
      name = "Lexend";
      package = pkgs.lexend;
      size = 11;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin-Mocha-Mauve-Dark";
      package = (pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = ["mauve"];
      });
    };
    gtk3.bookmarks = [
      "file:///home/cameron/github"
    ];
  };

  programs = {
    home-manager.enable = true;

    eza = {
      enable = true;
      enableAliases = false;
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
