{ pkgs, lib, inputs, ... }: rec {
  imports = [
    ./shell/xdg.nix
    ./shell/alacritty.nix
    ../git.nix
    ../zsh.nix

    ./userpackages.nix

    # ./sway.nix
    # ./hyprland
    # ./theme.nix
    # ./gnome-theme.nix
  ];

  home.username = "cameron";
  # home.homeDirectory = "/home/cameron";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "alacritty";
    BROWSER = "firefox";
  };

  systemd.user.sessionVariables = {
    # EXPERIMENTAL: breaks some electron apps
    # Also probably breaks on X11
    # Also makes a lot of electron apps use wayland
    NIXOS_OZONE_WL = "1";
    # ELECTRON_OZONE_PLATFORM_HINT = "wayland";
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
    poppler
  ];

  programs = {
    home-manager.enable = true;

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      icons = null;
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
