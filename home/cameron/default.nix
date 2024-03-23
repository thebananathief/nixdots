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
    # ./waybar.nix
    ./wlogout.nix
    ./kanshi.nix
    ./hyprland.nix
    ./dunst.nix
    # ./vscode.nix
    ./theme.nix
  ];

  home.username = "cameron";
  # home.homeDirectory = "/home/cameron";

  home.sessionVariables = {
  # systemd.user.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    # SHELL = "zsh";
    TERMINAL = "alacritty";
    BROWSER = "firefox";

    # Wakefield is the java wayland implementation
    # But OJDK16 can load in GTK3
    # This var fixes blank screens on launch
    _JAVA_AWT_WM_NONREPARENTING = "1";

    # Mozilla wayland support
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";

    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
    # GTK_USE_PORTAL = "1";
    GDK_BACKEND = "wayland";
    # GDK_BACKEND = "wayland,x11";
    
    # EXPERIMENTAL: breaks some electron apps
    # Also makes a lot of electron apps use wayland
    NIXOS_OZONE_WL = "1";
    # ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # home.sessionVariables = systemd.user.sessionVariables;

  # Install dotfiles repo and link configs
  # home.file."github/dotfiles" = {
  #   recursive = true;
  #   source = builtins.fetchGit {
  #     url = "https://github.com/thebananathief/dotfiles.git";
  #     ref = "main";
  #   };
  #   target = "./github/dotfiles";
  # };


  dconf.settings = {
    "org/cinnamon/desktop/applications/terminal".exec = "alacritty";
  };

  gtk = {
    enable = true;
    # These are referenced by Thunar for the navigation tree
    gtk3.bookmarks = [
      "file:///home/cameron/code"
      "file:///home/cameron/MEGA"
      "file:///home/cameron/Pictures"
      "file:///home/cameron/Downloads"
      "file:///mnt/talos" # refer to network-mounts
    ];
  };

  home.packages = with pkgs; [
    # Yazi previewers
    unar
    ffmpegthumbnailer
    jq
    poppler
  ];
  
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

    bat = {
      enable = true;
    };
  };

  # Auto-mounting removeable drives
  services.udiskie.enable = true;

  home.stateVersion = "23.05";
}
