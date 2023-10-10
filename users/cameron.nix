{ config, pkgs, ... }: { 
  #imports = [];

  home.username = "cameron";
  # home.homeDirectory = "/home/cameron";

  home.shellAliases = {
    edit = "$EDITOR";
    e = "$EDITOR";
    nic = "edit ~/github/nixdots";
    vic = "edit ~/github/dotfiles/.config/nvim";
  };
  
  #home.sessionVariables = {
  #  EDITOR = "nvim";
  #};

  home.packages = with pkgs; [
  # Utils
    eza
    ripgrep

  # fonts
    material-symbols
    noto-fonts
    noto-fonts-emoji
    roboto
    lexend
    jost
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

    neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        lsp-zero-nvim
        toggleterm-nvim
        nvim-tree-lua
        nvim-treesitter
        comment-nvim
        tagbar
        catppuccin-nvim
        feline-nvim
      ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
      
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;
      history.ignoreAllDups = true;
      oh-my-zsh = {
        enable = true;
        theme = "avit";
        plugins = [
          "git-auto-fetch"
          "sudo"
        ];
      };
      syntaxHighlighting.enable = true;
      dirHashes = {
        gits = "$HOME/github";
      };
      profileExtra = builtins.readFile "/home/cameron/github/dotfiles/.bash_aliases";
    };

    fzf = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    autojump = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = "thebananathief";
      userEmail = "cameron.salomone@gmail.com";
    };

    eza = {
      enable = true;
      enableAliases = true;
      icons = true;
    };
  };

  home.file.".bash_aliases".text = builtins.readFile "/home/cameron/github/dotfiles/.bash_aliases";

  # services.dunst = {
  #   enable = true;
  #   iconTheme = {
  #     name = "";
  #     package = pkgs.;
  #     size = "16x16";
  #   };
  #   settings = {
  #     global = {
  #       monitor = 0;
  #       font = "";
  #       width = 300;
  #       height = 200;
  #       origin = "top-right";
  #       offset = "24x24";
  #       scale = 0;
  #       notification_limit = 5;
  #       follow = "mouse";
  #       transparency = 10;
  #       
  #       progress_bar = true;
  #       progress_bar_height = 10;
  #     };
  #   };
  # };

  xdg = {
    enable = true;

    configFile."nvim" = {
      source = "/home/cameron/github/dotfiles/.config/nvim";
      target = "/home/cameron/.config/nvim";
      recursive = true;
    };

    desktopEntries."edit" = {
      name = "Edit w/ Neovim";
      genericName = "Neovim";
      comment = "Open the file in neovim on top of alacritty"; 
      icon = "neovim";
      terminal = true;
      exec = "${pkgs.neovim}";
      #exec = "${pkgs.alacritty}/bin/alacritty --command nvim";
      type = "Application";
      mimeType = [
        "text/plain"
      ];
      categories = [
        "TextEditor"
        "Utility"
      ];
    };
  };

  home.stateVersion = "23.05";
}
