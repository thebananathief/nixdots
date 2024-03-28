{ pkgs, lib, anyrun, ... }: {
# This module's purpose is to install a full desktop environment with Hyprland
# as the Window Manager. The scope of this should be as large as GNOME or Plasma.

  services.xserver.displayManager = {
    defaultSession = "hyprland";
    gdm.enable = true;
    gdm.wayland = true;
  };

  # systemd.tmpfiles.rules = [
  #   "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml}" ''
  #     <!-- this should all be copied from your ~/.config/monitors.xml -->
  #     <monitors version="2">
  #       <configuration>
  #           <!-- REDACTED -->
  #       </configuration>
  #     </monitors>
  #   ''}"
  # ];

  # environment.loginShellInit = ''
  #   [[ "$(tty)" == /dev/tty1 ]] && Hyprland
  # '';
  
  security.polkit.enable = true;

  environment = {
    sessionVariables = {
      POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      # POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-qt}/lib/libpolkit-qt5-agent-1.so.1.114.0";
    };

    systemPackages = (with pkgs; [
      intel-media-driver linux-firmware mesa
      
      anyrun.packages.${system}.anyrun
      hyprpicker
      dunst
      cliphist
      wl-clipboard
      wtype
      qt6.qtwayland
      brightnessctl
      libinput
      fusuma
      glib
      # waybar
      handlr
      trashy
      yad # dialog cli
      kanshi

      waylock
      swayidle # idle daemon to trigger sleep, suspend, monitor off, lock
      wlogout

      # Screen recording, region selection, screenshot markup UI, and the screencapping tool
      wf-recorder slurp swappy grim 
      
      nwg-drawer

      # Kinda broken with Hyprland or NixOS, not sure, but helps with generating configs to console
      # nwg-displays wlr-randr

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

      # gnome.nautilus
      cinnamon.nemo-with-extensions
    ]) ++ (with pkgs.libsForQt5; [
      # elisa
      # okular
      kcalc
      ark
      kclock
      # polkit-qt
      polkit-kde-agent
      qt5.qtwayland
      # dolphin
    ]);
  };

  programs.nautilus-open-any-terminal.enable = true;
  programs.nautilus-open-any-terminal.terminal = "alacritty";
  services.gnome.sushi.enable = true;

  security = {
    #pam.services.greetd.gnupg.enable = true;
    pam.services.waylock.text = "auth include login";
  };

  programs = {
    # Window manager
    hyprland.enable = true;
    hyprland.xwayland.enable = true;

    # GUI file explorer
    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];

    # GNOME network manager tray icon
    nm-applet.enable = true;

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
    # I think this breaks xdg-open slightly, can't open http
    # xdgOpenUsePortal = true;
    wlr.enable = lib.mkForce false;
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
