{ pkgs, config, ... }: rec {
  
  
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4"; # SUPER
      terminal = "${config.home.sessionVariables.TERMINAL}"; 
      menu = "anyrun";
      
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];

      # assigns = { };
      # bars = {};
    };

    wrapperFeatures = {
      gtk = true;
    };
    
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };
}
