{ pkgs, config, lib, ... }: rec {
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # SUPER
      terminal = "${config.home.sessionVariables.TERMINAL}"; 
      menu = "anyrun";
      
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];

      keybindings = lib.mkOptionDefault {
        "${modifier}+c" = "exec alacritty";
      };

      # assigns = { };
      # bars = {};
    };

    wrapperFeatures = {
      gtk = true;
    };
    
    extraSessionCommands = ''
      export CLUTTER_BACKEND=wayland
      export SDL_VIDEODRIVER=wayland
      
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1

      # fix invis cursor nvidia
      export WLR_NO_HARDWARE_CURSORS=1
      
      # screen flicker shit
      export WLR_RENDERER="vulkan"

      # xwayland flicker shit
      export XWAYLAND_NO_GLAMOR=1

      # more nvidia stuff from hyprland
      # export LIBVA_DRIVER_NAME=nvidia
      # export __GLX_VENDOR_LIBRARY_NAME=nvidia
      # export XDG_SESSION_TYPE=wayland
    '';
  };
}
