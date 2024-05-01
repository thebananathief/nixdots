{ pkgs, lib, inputs, globalFonts, ... }: rec {
  imports = [
    ./xdg.nix
    ./git.nix
    ./alacritty.nix
    ./zsh.nix
    ./hyprland.nix
    # ./sway.nix
    ./packages.nix
    ./theme.nix
  ];

  home.username = "cameron";
  # home.homeDirectory = "/home/cameron";

  # Install dotfiles repo and link configs
  # home.file."github/dotfiles" = {
  #   recursive = true;
  #   source = builtins.fetchGit {
  #     url = "https://github.com/thebananathief/dotfiles.git";
  #     ref = "main";
  #   };
  #   target = "./github/dotfiles";
  # };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "alacritty";
    BROWSER = "firefox";
    
    # EXPERIMENTAL: breaks some electron apps
    # Also probably breaks on X11
    # Also makes a lot of electron apps use wayland
    NIXOS_OZONE_WL = "1";
    # ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

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
