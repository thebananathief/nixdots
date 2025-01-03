{ pkgs, config, ... }: rec {
  imports = [
    ./zathura.nix
    ./fusuma.nix
    ./anyrun.nix
    ./waybar.nix
    ./wlogout.nix
    # ./kanshi.nix
    ./dunst.nix
  ];
  
  home.shellAliases = {
    dup = "alacritty --working-directory '$(pwd)' &";
    fonts = "yad --font | wl-copy";
    lf = "yazi";
    ii = "thunar";
  };

  # home.sessionVariables = {
  # # systemd.user.sessionVariables = {
  #   # For SDL2, NOTE: Steam, most games and other binary apps may not work with "wayland" SDL driver, unset or tweak for specific apps
  #   # Noita definitely needs this unset in its launch opts: env --unset=SDL_VIDEODRIVER %command%
  #   # https://wiki.libsdl.org/SDL2/FAQUsingSDL
  #   # SDL_VIDEODRIVER = "wayland";
  #   
  #   XDG_SESSION_TYPE = "wayland";
  #   CLUTTER_BACKEND = "wayland";
  #   WLR_RENDERER = "vulkan";
  #   # GTK_USE_PORTAL = "1";
  #   
  #   # GTK3 selects wayland by default, these break some apps if you set them (sway docs)
  #   # GDK_BACKEND = "wayland";
  #   # GDK_BACKEND = "wayland,x11";
  #       
  #   # GDK_SCALE = "1";
  #   QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  #   # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  #   # QT_FONT_DPI = "128";
  # };

  # systemd.user.sessionVariables = home.sessionVariables;
  # systemd.user.sessionVariables = {
  #   
  # };
  
  programs.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "/home/cameron/Wallpapers/";
        duration = "30m";
        apply-shadow = true;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "alacritty";
      "$files" = "thunar";
      "$browser" = "firefox";
      "$runner" = "anyrun";
      "$volume" = "~/code/nixdots/scripts/volumecontrol";
      "$lockscreen" = "waylock -init-color 0x101010 -input-color 0x353535 -fail-color 0x150505";
      "$lockmenu" = "wlogout";
      "$brightness" = "~/code/nixdots/scripts/brightnesscontrol";
      "$screenshot" = "~/code/nixdots/scripts/screenshot";

      env = [
        # NVIDIA stuff
        "WLR_NO_HARDWARE_CURSORS,1" # Fixes disappeared cursor on NVIDIA
        "LIBVA_DRIVER_NAME,nvidia" # Hardware Accel for GPU
        "WLR_DRM_NO_ATOMIC,1" # Might fix flickering

        # To force GBM as a backend
        # "GBM_BACKEND,nvidia-drm" # works fine when commented?
        # if windows don't display or screen share doesnt work, remove this
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        
        # "XDG_SESSION_TYPE,wayland" # apparently Hyprland sets this by default, but their docs do recommend setting it and other xdg specs
        "CLUTTER_BACKEND,wayland"
        # "WLR_RENDERER,vulkan" # commenter on reddit said Hyprland doesn't have a Vulkan backend, so this doesn't do anything
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        
        # May break launching games (i think these may be defaults)
        # "SDL_VIDEODRIVER,x11"
        # "GDK_BACKEND,x11"
        
        # "SDL_VIDEODRIVER,wayland" # Breaks some games (can't launch)
        "GDK_BACKEND,wayland,x11" # Breaks some apps if set (sway docs)
    
        "__GL_VRR_ALLOWED,1" # If adaptive sync should be used, recommended 0 to avoid problems with games
        "__GL_GSYNC_ALLOWED,1" # If G-Sync monitors should use VRR, recommended 0

        # Fix for some Java AWT applications (e.g. Android Studio), this var fixes blank screens on launch
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "__NV_PRIME_RENDER_OFFLOAD,1"
        "__VK_LAYER_NV_optimus,NVIDIA_only"
        "PROTON_ENABLE_NGX_UPDATER,1"
        "NVD_BACKEND,direct"
        "WLR_USE_LIBINPUT,1"
        # "XWAYLAND_NO_GLAMOR,1"
        "__GL_MaxFramesAllowed,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
      ];

      # These are ran every reload of hyprland
      exec = [
      ];

      exec-once = [
        "wl-paste --type text --watch cliphist store" #Stores only text data
        "wl-paste --type image --watch cliphist store" #Stores only image data

        # Taken from CTT
        # "~/code/nixdots/scripts/resetxdgportal"
        # For when xdg-desktop-portal-wlr doesn't want to start because these variables are missing
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        # "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        # "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

        "wpaperd"
        "waybar"
        "blueman-applet"
        # "nm-applet --indicator" # started by nixos module
        "mega-cmd"
        "firefox"
        "~/code/nixdots/scripts/batterynotify"
        # "kanshi"
        "swayidle -w timeout 600 '~/code/nixdots/scripts/lock' timeout 615 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
        "hyprctl setcursor \"${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}\""
        "kvantummanager --set Catppuccin-Mocha-Mauve"
        
        # BUG: mullvad and tailscale networks conflict
        "tailscale-systray"
        
        # For touchpad gestures, only needed on laptop
        # "fusuma -d"
      ];

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        # desktop
        "desc:AOC 27G15 AH15332Z02979,1920x1080@180,0x-1080,1.0"
        "desc:AOC 27G15 AH15332Z02974,1920x1080@180,0x0,1.0"
        "desc:Lenovo Group Limited D27-30 URHHM364,1920x1080@75,1920x-500,1.0"
        "desc:Lenovo Group Limited D27-30 URHHM364,transform,1"

        # laptop @ work
        # "eDP-1, highres, 0x0, auto"
        # "DP-1, highres, 0x0, auto"
        # "DP-5, highres, 1128x0, auto"
        # "DP-6, highres, 3048x0, auto"

        # laptop alone
        # "eDP-1, highres, auto, auto"

        # catchall monitor rule
        # ", preferred, auto, 1"
      ];

      # workspace = [
        # desktop setup
        # "1, monitor:HDMI-A-1, default:true"
        # "2, monitor:DP-3, default:true"
        # "3, monitor:DP-1, default:true"

        # laptop setup
        # "1, monitor:eDP-1, default:true, persistent:true"
        # "2, monitor:DP-5, default:true, persistent:true"
        # "3, monitor:DP-6, default:true, persistent:true"
        # "2, monitor:DP-7, default:true, persistent:true"
        # "3, monitor:DP-8, default:true, persistent:true"
        # "2, monitor:HP Inc. HP V24 1CR0440LFS, default:true, persistent:true"
        # "3, monitor:HP Inc. HP V214a CNC7160VL4, default:true, persistent:true"
      # ];

      # xwayland = {
      #   use_nearest_neighbor = true;
      #   force_zero_scaling = true;
      # };

      # https://wiki.hyprland.org/Configuring/Binds/
      bind = [
        # Common apps
        "$mainMod, A, exec, $terminal"
        "$mainMod, E, exec, $files"
        "$mainMod, S, exec, spotify"
        "$mainMod, F, exec, $browser"
        "$mainMod, D, exec, obsidian"
        "$mainMod, C, exec, hyprpicker -a -n"

        # Test buttons to restart waybar and print active window info
        "$mainMod, U, exec, hyprctl activewindow | yad --text-info --width 50 --height 400 --no-buttons --undecorated --escape-ok"
        "$mainMod, Y, exec, killall .waybar-wrapped ; waybar"
        "$mainMod, Y, exec, killall .fusuma-wrapped ; fusuma -d"
        "$mainMod, Y, exec, killall blueman-applet ; blueman-applet"
        "$mainMod, Z, exec, ~/code/nixdots/scripts/resetxdgportal"

        # Media key binds
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"

        # Screenshot/Screencapture
        "$mainMod SHIFT, S, exec, $screenshot s" # screenshot snip
        "$mainMod SHIFT, Q, exec, $screenshot w" # screenshot active window
        "$mainMod SHIFT, W, exec, $screenshot p" # print current screen

        # Window actions
        # mouse 274 = middle
        # mouse 275 = mouse button 4 (back)
        # mouse 276 = mouse button 5 (forward)
        "$mainMod, W, killactive,"
        "ALT, return, fullscreen,"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, mouse:276, pseudo," # dwindle
        # "$mainMod, I, togglegroup"
        # "$mainMod, mouse:276, togglegroup"
        "$mainMod, M, togglesplit," # dwindle
        "$mainMod, mouse:275, togglesplit," # dwindle
        "$mainMod, O, togglefloating,"
        "$mainMod, mouse:274, togglefloating,"

        # Cycle window focus
        "$mainMod, Tab, cyclenext,"
        "$mainMod, Tab, bringactivetotop,"
        "ALT, Tab, movefocus, d"
        "ALT, Tab, bringactivetotop,"

        # Focus window in a direction
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Move focused window in a direction
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        # Swap focused window with other in direction
        "$mainMod CTRL, H, swapwindow, l"
        "$mainMod CTRL, L, swapwindow, r"
        "$mainMod CTRL, K, swapwindow, u"
        "$mainMod CTRL, J, swapwindow, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        "$mainMod, F1, exec, ~/code/nixdots/scripts/gamemode" # disable hypr effects for gamemode
      ];

      binde = [
        # Resize windows
        "$mainMod, right, resizeactive, 30 0"
        "$mainMod, left, resizeactive, -30 0"
        "$mainMod, up, resizeactive, 0 -30"
        "$mainMod, down, resizeactive, 0 30"

        # Volume keys
        ", XF86AudioRaiseVolume, exec, $volume -o i"
        ", XF86AudioLowerVolume, exec, $volume -o d"

        # Brightness control
        ", XF86MonBrightnessUp, exec, $brightness i"
        ", XF86MonBrightnessDown, exec, $brightness d s"
      ];

      bindr = [
        "$mainMod, space, exec, pkill .$runner-wrapped || $runner" # launch desktop applications
        "$mainMod, R, exec, killall nwg-drawer || nwg-drawer" # launch desktop applications
        # "$mainMod, T, exec, killall $runner; $runner --plugins kidex " # browse system files
        # "$mainMod, V, exec, cliphist list | anyrun --dmenu | cliphist decode | wl-copy" # clipboard chooser

        # Mod-Q to lock Mod-Ctrl-Q to get logout menu
        "$mainMod, Q, exec, $lockscreen" # lock screen
        "$mainMod Ctrl, Q, exec, pkill $lockmenu || $lockmenu" # logout menu
      ];

      bindl = [
        ## Trigger when the switch is turning off
        # ", switch:on:Lid Switch, exec, $lockscreen && systemctl suspend"
        ", switch:off:Lid Switch, exec, $lockscreen && systemctl suspend"
        # hyprctl keyword monitor "eDP-1, disable"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      misc = {
        vrr = 0;
        vfr = true;
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        #enable_swallow = true;
      };

      input = {
        kb_layout = "us";
        # kb_variant =
        # kb_model =
        # kb_options =
        # kb_rules =

        follow_mouse = true;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        force_no_accel = true;
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 2;

        # COLORS
        "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        "col.nogroup_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        # "col.nogroup_border_active" =
        resize_on_border = true;

        # allow_tearing = true;

        layout = "dwindle";
      };

      # group = {
      #   "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        # "col.border_inactive" =
        # "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        # "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
      # };

      decoration = {
        rounding = 10;
        drop_shadow = false;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          new_optimizations = true;
          xray = true;
        };
      };

      # Not very documented, but enables blur under these gtk-layer-shell namespaces
      blurls = [
        "waybar"
      ];

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        no_gaps_when_only = true;
      };

      master.new_is_master = false;

      gestures.workspace_swipe = true;
      gestures.workspace_swipe_fingers = 4;

      # device = {
      #   "logitech-m510".sensitivity = 1.0;
      #   "logitech-g203-prodigy-gaming-mouse".sensitivity = -0.2;
      #   "pixa3854:00-093a:0274-touchpad".sensitivity = 1.0;
      #   "glorious-model-d".sensitivity = -0.5;
      # };

      animations = {
        enabled = "yes";
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 5, wind, slide"
          "windowsIn, 1, 5, winIn, slide"
          "windowsOut, 1, 4, winOut, slide"
          "windowsMove, 1, 4, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 4, wind"
        ];
      };

      windowrulev2 = [
        # "float, title:notification"
        # "float, title:dialog"
        # "float, title:confirm"
        # "float, title:error"
        # "float, title:download"
        # "float, title:attention"
        # "float, title:save"
        "float, title:^(Picture-in-Picture)$"
        "float, title:^(File Operation Progress)$"
        "float, title:^(Confirm to replace files)$"
        "float, title:^(Open folder as vault)$"
        # "forcergbx, title:(Save)"
        # "noblur, title:(Save)"

        # "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        # "size 20% 20%, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        # "center, class:^(org.kde.polkit-kde-authentication-agent-1)$"

        # "float, class:^(firefox), title:^(Extension: \(Bitwarden (-|—) Free Password Manager\) (-|—) Bitwarden (-|—) Mozilla Firefox)"
        "float, title:^(Extension:)"
        "float, class:(pavucontrol|yad|nm-connection-editor|nm-applet|blueman-manager)"
        "float, class:(qt5ct|qt6ct|kvantummanager|nwg-look)"

        # fix xwayland apps
        "rounding 0, xwayland:1, floating:1"
        
        "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
        "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"

        # Fix tooltips taking away window focus
        # https://github.com/hyprwm/Hyprland/issues/2412
        "nofocus,class:^jetbrains-(?!toolbox),floating:1,title:^win\d+"

        "size 20% 40%, class:^(org.kde.kcalc)$"
        "float, class:^(org.kde.kcalc)$"

        # "idleinhibit fullscreen, class:^(firefox)$"
      ];
    };
  };

  xdg.configFile."hypr/hyprland.conf".force = true;
}




# Window/Session actions
#bind = ALT, F4, exec, ~/code/nixdots/scripts/dontkillsteam # killactive, kill the window on focus
#bind = $mainMod, delete, exit, # kill hyperland session
#bind = $mainMod, W, togglefloating, # toggle the window on focus to float
#bind = $mainMod, G, togglegroup, # toggle the window on focus to float

