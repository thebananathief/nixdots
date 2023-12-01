{ pkgs, lib, inputs, ... }: rec {
  imports = [
    ./xdg.nix
    ./git.nix
    ./alacritty.nix
    ./zsh.nix
    # ./neovim.nix
    ./zathura.nix
    ./fusuma.nix
    ./anyrun.nix
    ./waybar.nix
    ./hyprland.nix
    ./swaylock.nix
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

    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
    GTK_USE_PORTAL = "1";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # NIXOS_OZONE_WL = "1";
  };

  # sessionVariables = {
  #   GTK_THEME = "Catppuccin-Mocha-Compact-Mauve-Dark";
    # GDK_SCALE = "1";
    # XCURSOR_SIZE = "32";
    # XCURSOR_THEME = "Bibata-Modern-Ice";
  # };
    
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
    name = "Catppuccin-Mocha-Mauve";
    package = pkgs.catppuccin-cursors.mochaMauve;
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
      document-font-name = "Lexend 10";
      monospace-font-name = "FiraMono Nerd Font Mono 10";
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
  };

  # Auto-mounting removeable drives
  services.udiskie.enable = true;
    
  home.stateVersion = "23.05";
}
