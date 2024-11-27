{ pkgs, ... }: {
  # imports = [
  #   ../games.nix
  # ];

  services = {
    # xserver = {
    #   enable = true;
    #   xkb.layout = "us";
    #   xkb.variant = "";
    #   desktopManager.plasma5.enable = true;
    # # excludePackages = [ pkgs.xterm ];
    # };
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
#    displayManager.defaultSession = "plasmawayland";
  };


  # environment.variables = {
  environment.sessionVariables = {
    # For SDL2, NOTE: Steam, most games and other binary apps may not work with "wayland" SDL driver, unset or tweak for specific apps
    # Noita definitely needs this unset in its launch opts: env --unset=SDL_VIDEODRIVER %command%
    # https://wiki.libsdl.org/SDL2/FAQUsingSDL
    # SDL_VIDEODRIVER = "wayland";
    
    # XDG_SESSION_TYPE = "wayland";
    # CLUTTER_BACKEND = "wayland";
    # WLR_RENDERER = "vulkan";
    # GTK_USE_PORTAL = "1";
    
    # GTK3 selects wayland by default, these break some apps if you set them (sway docs)
    # GDK_BACKEND = "wayland";
    # GDK_BACKEND = "wayland,x11";
        
    # GDK_SCALE = "1";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # QT_FONT_DPI = "128";
  };

  # environment.systemPackages = (with pkgs; [
  #
  # ]) ++ (with pkgs.libsForQt5; [
  #
  # ]);

#  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
#    elisa
#    gwenview
#    okular
#    oxygen
#    khelpcenter
#    konsole
#    plasma-browser-integration
#    print-manager
#  ];

  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   plasma-browser-integration
  #   konsole
  #   oxygen
  # ];
}
