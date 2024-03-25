{ pkgs, lib, anyrun, ... }: {
  # imports = [
  #   ../greetd.nix
  # ];
  
  # services.xserver.displayManager = {
  #   defaultSession = "sway";
  #   gdm.enable = true;
  #   gdm.wayland = true;
  # };

  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';
  
  security.polkit.enable = true;
    
  environment.sessionVariables = {
    POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
    # POLKIT_AUTH_AGENT = "${pkgs.libsForQt5.polkit-qt}/lib/libpolkit-qt5-agent-1.so.1.114.0";
  };
  
  environment.systemPackages = (with pkgs; [
    kanshi
    dunst
    trashy
    yad
    swayidle
    wlogout
    waylock

    wf-recorder # screen recording
    slurp # select region for screenshot
    swappy # edit screenshots after clipping
    grim # screen capture for screenshots

    nwg-drawer
    nwg-displays # seemed broken last i checked
    
    # Media
    zathura # docs
    mpv     # video & audio
    imv     # image

    # Audio
    playerctl
    pavucontrol
    ncpamixer
    pamixer
    amberol
  ]) ++ (with pkgs.libsForQt5; [
    kcalc
    ark
    kclock
    polkit-kde-agent
    qt5.qtwayland
  ]);
  
  security = {
    #pam.services.greetd.gnupg.enable = true;
    pam.services.waylock.text = "auth include login";
  };
  
  programs = {
    # GUI file explorer
    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  #
  #   # GNOME network manager tray icon
  #   nm-applet.enable = true;
  #
  #   # Monitor backlight control
  #   # light.enable = true;
  };

  services = {
    gnome.gnome-keyring.enable = true;
  
    # Addons for thunar to detect USB devices and display thumbnails
    gvfs.enable = true;
    tumbler.enable = true;
  #
  #   udisks2.enable = true;
  #   blueman.enable = true;
  };
  
  # programs = {
  #   sway = {
  #     enable = true;
  #     wrapperFeatures.gtk = true;
  #
  #     extraPackages = with pkgs; [
  #
  #     ];
  #
  #     extraSessionCommands = ''
  #       # SDL:
  #       export SDL_VIDEODRIVER=wayland
  #       
  #       # QT (needs qt5.qtwayland in systemPackages):
  #       export QT_QPA_PLATFORM=wayland-egl
  #       export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  #       
  #       # Fix for some Java AWT applications (e.g. Android Studio),
  #       # use this if they aren't displayed properly:
  #       export _JAVA_AWT_WM_NONREPARENTING=1
  #     '';
  #   };
  # };
}
