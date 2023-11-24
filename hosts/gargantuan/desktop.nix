{ pkgs, ... }: {
  environment = {
    sessionVariables = {
      #POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-qt}/lib/libpolkit-qt5-agent-1.so.1.114.0";
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
      yad # dialog cli

      wf-recorder # screen recording
      grim # screenshots
      slurp # select region for screenshot

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
      # libsForQt5.elisa
      # clapper
      # libsForQt5.okular
      # viewnior # image

    # Audio
      playerctl
      pavucontrol
      ncpamixer
      pamixer
      amberol # audio

      # alsa-utils # may be added by programs or services
      # mako # notify daemon
      # mpd # audio player
      # mpc-cli # cli mpd interface
      # ncmpcpp # curses mpd interface
    ];
  };

  environment.pathsToLink = [ "/libexec" ];

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

    # Monitor backlight control
    light.enable = true;

    # Start the ssh-agent for ssh passphrases
    ssh.startAgent = true;
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
    desktopManager.xterm.enable = false;

    displayManager = {
      defaultSession = "hyprland";
      gdm.enable = true;
      gdm.wayland = true;
    };

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
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-xapp
      # libsForQt5.xdg-desktop-portal-kde
      # xdg-desktop-portal-gnome
      # lxqt.xdg-desktop-portal-lxqt
    ];
  };
}
