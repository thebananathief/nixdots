# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [ 
    ./hardware-configuration.nix
  ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ intel-media-driver ];
    };
    pulseaudio.enable = false;
    bluetooth.enable = true;
  };

  networking = {
    hostName = "gargantuan";
    networkmanager.enable = true;
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure X11, desktop, and keymap
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    excludePackages = [ pkgs.xterm ];

    # Desktop Environments
    #desktopManager.plasma5.enable = true;
    #desktopManager.plasma5.useQtScaling = true;
    #desktopManager.gnome.enable = true;

    # Display managers
    #displayManager.sddm.enable = true;
    #displayManager.sddm.enableHidpi = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    #displayManager.lightdm.enable = true;

    # Window Managers

    libinput = {
      enable = true;
      touchpad = {
        accelProfile = "flat";
        accelSpeed = "0.5";
        naturalScrolling = false;
      };
      mouse = {
        accelProfile = "flat";
        accelSpeed = "1.0";
        naturalScrolling = false;
      };
    };
  };

  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        #xdg-desktop-portal-wlr
        #xdg-desktop-portal-gtk
        #xdg-desktop-portal-xapp
        #libsForQt5.xdg-desktop-portal-kde
        #xdg-desktop-portal-gnome
        xdg-desktop-portal-hyprland
        #lxqt.xdg-desktop-portal-lxqt
      ];
    };
  };

  services = {
    gvfs.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    printing.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    fprintd.enable = true;
    flatpak.enable = true;
    tumbler.enable = true;
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
        NMI_WATCHDOG = 0;
      };
    };
  };

  programs = {
    hyprland.enable = true;
    hyprland.xwayland.enable = true;
    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    zsh = {
      enable = true;
      ohMyZsh.enable = true;
      autosuggestions.enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.cameron = {
    isNormalUser = true;
    description = "Cameron";
    extraGroups = [ "networkmanager" "wheel" "network" "input" ];
  };

  security = {
    sudo.wheelNeedsPassword = false;
    rtkit.enable = true;
    polkit.enable = true;
    #pam.services.greetd.gnupg.enable = true;
    pam.services.swaylock.text = "auth include login";
  };

  nix.settings.trusted-users = [ "root" "cameron"];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Fonts
  fonts = {
    packages = with pkgs; [
      # fira-code
      # fira
      # cooper-hewitt
      # ibm-plex
      # iosevka
      # bitmap
      # spleen
      # fira-code-symbols
      # powerline-fonts
      material-symbols
      noto-fonts
      noto-fonts-emoji
      roboto
      lexend
      jost
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "FiraMono" "Meslo" "MPlus" "RobotoMono" ]; })
    ];

    enableDefaultPackages = false;

    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  environment = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERM = "alacritty";
      MOZ_ENABLE_WAYLAND = "1";
      #POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-qt}/lib/libpolkit-qt5-agent-1.so.1.114.0";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      #WLR_RENDERER = "vulkan";
      #WLR_RENDERER = "pixman";
      WLR_NO_HARDWARE_CURSORS = "1";
      GTK_USE_PORTAL = "1";
      GDK_SCALE = "1";
      GDK_BACKEND = "wayland,x11";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_PICTURES_DIR = "$HOME/Pictures";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_STYLE_OVERRIDE = "kvantum";
      NIXOS_OZONE_WL = "1";

      GTK_THEME = "Catppuccin-Mocha-Compact-Mauve-Dark";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      XCURSOR_SIZE = "24";
      XCURSOR_THEME = "Bibata-Modern-Ice 24";
    };

    systemPackages = with pkgs; [
    ## CLI
      zsh
      fzf
      neofetch
      btop
      htop
      ethtool
      just
      wget
      universal-ctags
      tree
      multitail
      dos2unix
      tldr
      curl
      alacritty
      wgnord
      tmux
      cage
      autojump
      unzip
      zig
      ranger
      wev
      killall
      imagemagick
      broot
      fd
      ncpamixer
      dua
      ffmpegthumbnailer
      efibootmgr
      fontconfig
      fontfor
      fontpreview
      #cut

    ## Desktop environment
      gsettings-qt
      gsettings-desktop-schemas
      gnome.dconf-editor
      xsettingsd
      intel-media-driver
      linux-firmware
      mesa
      rofi-wayland
      rofi-rbw
      rofi-calc
      rofi-vpn
      rofi-bluetooth
      rofi-file-browser
      hyprpaper
      hyprpicker
      xwayland
      #gnome.nautilus
      #nautilus-open-any-terminal
      #gnome.sushi
      nwg-look
      nwg-displays
      dunst
      cliphist
      wl-clipboard
      udiskie
      networkmanagerapplet
      #libsForQt5.networkmanager-qt # alternative nm-tray
      wtype
      polkit
      libsForQt5.polkit-qt
      #libsForQt5.polkit-kde-agent
      #libsForQt5.elisa
      clapper
      libsForQt5.breeze-grub
      libsForQt5.kcalc
      libsForQt5.okular
      libsForQt5.ark
      libsForQt5.kclock
      libsForQt5.qt5ct
      libsForQt5.qt5.qtwayland
      libsForQt5.qtstyleplugin-kvantum
      qt6.qtwayland
      qt6Packages.qt6ct
      catppuccin-kvantum
      catppuccin-cursors
      (catppuccin-gtk.override {
        accents = ["mauve"];
        size = "compact";
        variant = "mocha";
      })
      #catppuccin-kde
      #tela-icon-theme
      bibata-cursors
      papirus-icon-theme
      playerctl
      pavucontrol
      pamixer
      wlogout
      brightnessctl
      #bluez
      swayidle
      #swaylock
      swaylock-effects
      libinput
      libinput-gestures
      glib
      waybar
      handlr
      viewnior
      trashy
      amberol

    ## Coding
      git
      neovim
      go
      nodejs-slim
      rustup

    ## General desktop
      krita
      libreoffice
      firefox
      megacmd
      obsidian
      spotify
      spicetify-cli
      discord
      bitwarden
      starship
      #trayscale
      tailscale-systray
      # thunderbird
      # parsec-bin
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

