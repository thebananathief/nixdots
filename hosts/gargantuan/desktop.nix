{ pkgs, ... }: {
  environment = {
    sessionVariables = {
      #POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-qt}/lib/libpolkit-qt5-agent-1.so.1.114.0";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      # WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
      GTK_USE_PORTAL = "1";
      GDK_BACKEND = "wayland,x11";
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [
      intel-media-driver
      linux-firmware
      mesa
      hyprpaper
      hyprpicker
      dunst
      cliphist
      wl-clipboard
      udiskie
      wtype
      polkit
      libsForQt5.polkit-qt
      #libsForQt5.polkit-kde-agent
      libsForQt5.qt5.qtwayland
      qt6.qtwayland
      wlogout
      brightnessctl
      #bluez
      swayidle
      swaylock-effects
      libinput
      fusuma
      glib
      waybar
      handlr
      trashy

    # General DE programs
      libsForQt5.kcalc
      libsForQt5.ark
      libsForQt5.kclock
      nwg-displays
      wlr-randr
      networkmanagerapplet
      #libsForQt5.networkmanager-qt # alternative nm-tray
      
    # Media
      zathura # docs
      mpv     # video & audio
      imv     # image
      #libsForQt5.elisa
      # clapper
      # libsForQt5.okular
      playerctl
      pavucontrol
      ncpamixer
      pamixer
      amberol # audio
      # viewnior # image
    ];
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    #pam.services.greetd.gnupg.enable = true;
    pam.services.swaylock.text = "auth include login";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # enable location service
  # location.provider = "geoclue2";

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

  # Window manager and GUI file explorer
  programs = {
    hyprland.enable = true;
    hyprland.xwayland.enable = true;
    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  services = {
    gvfs.enable = true;
    tumbler.enable = true;

    blueman.enable = true;
    printing.enable = true;
    flatpak.enable = true;
    
    # use Ambient Light Sensors for auto brightness adjustment
    # clight = {
    #   enable = true;
    #   settings = {
    #     verbose = true;
    #     dpms.timeouts = [900 300];
    #     dimmer.timeouts = [870 270];
    #     screen.disabled = true;
    #   };
    # };
  };

  # Configure X11, desktop, and keymap
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    excludePackages = [ pkgs.xterm ];

    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;

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

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    # wlr.enable = true;
    # extraPortals = with pkgs; [
      #xdg-desktop-portal-wlr
      #xdg-desktop-portal-gtk
      #xdg-desktop-portal-xapp
      #libsForQt5.xdg-desktop-portal-kde
      #xdg-desktop-portal-gnome
      #lxqt.xdg-desktop-portal-lxqt
    # ];
  };
}
