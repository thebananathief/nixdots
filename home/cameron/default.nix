{ pkgs, lib, inputs, globalFonts, ... }: rec {
  imports = [
    ./xdg.nix
    ./git.nix
    ./alacritty.nix
    ./zsh.nix
    # ./neovim.nix
    ./spicetify.nix
    ./zathura.nix
    ./fusuma.nix
    ./anyrun.nix
    ./waybar.nix
    ./wlogout.nix
    ./kanshi.nix
    ./hyprland.nix
    ./dunst.nix
  ];

  home.username = "cameron";
  # home.homeDirectory = "/home/cameron";

  systemd.user.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    # SHELL = "zsh";
    TERMINAL = "alacritty";
    BROWSER = "firefox";

    # Wakefield is the java wayland implementation
    # But OJDK16 can load in GTK3
    # This var fixes blank screens on launch
    _JAVA_AWT_WM_NONREPARENTING = "1";

    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";

    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
    GTK_USE_PORTAL = "1";
    # GDK_BACKEND = "wayland,x11";
    GDK_BACKEND = "wayland";
    # GDK_SCALE = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # QT_AUTO_SCREEN_SCALE_FACTOR = "1";

    # EXPERIMENTAL: breaks some electron apps
    NIXOS_OZONE_WL = "1";
    # ELECTRON_OZONE_PLATFORM_HINT = "wayland";
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

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    # name = "Catppuccin-Mocha-Mauve";
    # package = pkgs.catppuccin-cursors.mochaMauve;
    size = 24;
    gtk.enable = true;
    # x11.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      document-font-name = "${globalFonts.sansSerif} 10";
      monospace-font-name = "${globalFonts.monospace} 10";
      # font-antialiasing = "rgba";
      # font-hinting = "full";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "Lexend";
      package = pkgs.lexend;
      size = 10;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = ["mauve"];
        size = "compact";
      };
    };

    # These are referenced by Thunar for the navigation tree
    gtk3.bookmarks = [
      "file:///home/cameron/github"
      "file:///home/cameron/MEGA"
      "file:///home/cameron/Pictures"
    ];
  };

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
      # settings = {
      #   manager.show_hidden = true;
      # };
    };

    bat = {
      enable = true;
      # themes = {
      #   catppuccin = {
      #     src = pkgs.fetchFromGitHub {
      #       owner = "catppuccin";
      #       repo = "bat";
      #       rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
      #       sha256 = "8dda4ec4bac3fc29a2a8941a8b0756a8a16623bee1ff5bcfe1433aae74ca3453";
      #     };
      #     file = "Catppuccin-mocha.tmTheme";
      #   };
      # };
      config = {
        theme = "Catppuccin-mocha";
      };
    };
  };

  xdg.configFile."bat/themes/Catppuccin-mocha.tmTheme".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme";
    sha256 = "a8c40d2466489a68ebab3cbb222124639221bcf00c669ab45bab242cbb2783fc";
  };

  # Auto-mounting removeable drives
  services.udiskie.enable = true;

  home.stateVersion = "23.05";
}
