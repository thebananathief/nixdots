{ pkgs, anyrun, ... }: {
# This module's purpose is to install a full desktop environment with Hyprland
# as the Window Manager. The scope of this should be as large as GNOME or Plasma.

  services.xserver.displayManager = {
    defaultSession = "hyprland";
    gdm.enable = true;
    gdm.wayland = true;
  };

  environment = {
    sessionVariables = {
      #POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-qt}/lib/libpolkit-qt5-agent-1.so.1.114.0";
    };

    systemPackages = (with pkgs; [
      anyrun.packages.${system}.anyrun
      intel-media-driver
      linux-firmware
      mesa
      hyprpaper
      hyprpicker
      dunst
      cliphist
      wl-clipboard
      wtype
      qt6.qtwayland
      wlogout
      brightnessctl
      swayidle # idle daemon to trigger sleep, suspend, monitor off, lock
      libinput
      fusuma
      glib
      waybar
      handlr
      trashy
      yad # dialog cli

      wf-recorder # screen recording
      slurp # select region for screenshot
      swappy # edit screenshots after clipping
      grim # screen capture for screenshots

    # General DE programs
      nwg-displays
      wlr-randr
      networkmanagerapplet
      
    # Media
      zathura # docs
      mpv     # video & audio
      imv     # image
      # clapper
      # viewnior # image

    # Audio
      playerctl
      pavucontrol
      ncpamixer
      pamixer
      amberol

      # alsa-utils # may be added by programs or services
      # mako # notify daemon
      # mpd # audio player
      # mpc-cli # cli mpd interface
      # ncmpcpp # curses mpd interface
    ]) ++ (with pkgs.libsForQt5; [
      # elisa
      # okular
      kcalc
      ark
      kclock
      polkit-qt
      # polkit-kde-agent
      qt5.qtwayland
      networkmanager-qt # alternative nm-tray
    ]);
  };

  security = {
    rtkit.enable = true;
    #pam.services.greetd.gnupg.enable = true;
    pam.services.swaylock.text = "auth include login";
  };
  
  programs = {
    # Window manager
    hyprland.enable = true;
    hyprland.xwayland.enable = true;

    # GUI file explorer
    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];

    # Monitor backlight control
    # light.enable = true;
  };

  # For flatpaks I think?
  #  environment.pathsToLink = [ "/libexec" ];
  #services.flatpak.enable = true;

  services = {
    # Addons for thunar to detect USB devices and display thumbnails 
    gvfs.enable = true;
    tumbler.enable = true;
    
    udisks2.enable = true;
    blueman.enable = true;
    printing.enable = false;
    
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

  xdg.portal = {
    enable = true;
    # xdgOpenUsePortal = true;
    # wlr.enable = true;
    extraPortals = with pkgs; [
    #   xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    #   xdg-desktop-portal-xapp
    #   libsForQt5.xdg-desktop-portal-kde
    #   xdg-desktop-portal-gnome
    #   lxqt.xdg-desktop-portal-lxqt
    ];
  };
}
