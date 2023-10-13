{ pkgs, ... }: {
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mainMod" = "SUPER";

      # https://wiki.hyprland.org/Configuring/Binds/
      bind = [
        # Commonn apps
        "$mainMod, A, exec, alacritty"
        "$mainMod, E, exec, thunar"
        "$mainMod, S, exec, spotify"
        "$mainMod, F, exec, firefox"
        "$mainMod, D, exec, obsidian"
        "$mainMod, C, exec, hyprpicker -a -n"

        # Test buttons to restart waybar and print active window info
        "$mainMod, U, exec, hyprctl activewindow >> ~/text.txt"
        "$mainMod, Y, exec, killall .waybar-wrapped ; waybar"
        
        # Media key binds
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"

        # Window actions
        "$mainMod, W, killactive,"
        "$mainMod, O, togglefloating,"
        "$mainMod, I, togglegroup"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, M, togglesplit," # dwindle
        "ALT, return, fullscreen,"

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

        "$mainMod, F5, exec, ~/.config/hypr/scripts/gamemode.sh" # disable hypr effects for gamemode
      ];

      binde = [
        # Resize windows
        "$mainMod, right, resizeactive, 10 0"
        "$mainMod, left, resizeactive, -10 0"
        "$mainMod, up, resizeactive, 0 -10"
        "$mainMod, down, resizeactive, 0 10"

        # Volume keys
        ", XF86AudioRaiseVolume, exec, ~/.config/hypr/scripts/volumecontrol.sh -o i"
        ", XF86AudioLowerVolume, exec, ~/.config/hypr/scripts/volumecontrol.sh -o d"

        # Brightness control
        ", XF86MonBrightnessUp, exec, ~/.config/hypr/scripts/brightnesscontrol.sh i"
        ", XF86MonBrightnessDown, exec, ~/.config/hypr/scripts/brightnesscontrol.sh d s"
      ];

      bindr = [
        # Rofi stuff
        "$mainMod, R, exec, pkill rofi || ~/.config/hypr/scripts/rofilaunch.sh d" # launch desktop applications
        # "$mainMod, tab, exec, pkill rofi || ~/.config/hypr/scripts/rofilaunch.sh w" # switch between desktop applications
        "$mainMod, T, exec, pkill rofi || ~/.config/hypr/scripts/rofilaunch.sh f" # browse system files
        "$mainMod, G, exec, pkill rofi || ~/.config/hypr/scripts/gamelauncher.sh 3" # steam game launcher
        # "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy" # clipboard chooser

        # Mod-Q to lock Mod-Ctrl-Q to get logout menu
        "$mainMod, Q, exec, ~/.config/hypr/scripts/lock.sh" # lock screen
        "$mainMod Ctrl, Q, exec, ~/.config/hypr/scripts/logoutlaunch.sh 1" # logout menu
      ];

      bindl = [
        ## Trigger when the switch is turning off
        ", switch:on:Lid Switch, exec, ~/.config/hypr/scripts/lock.sh && systemctl suspend"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      exec-once = [
        # "~/.config/hypr/scripts/resetxdgportal.sh"
        "~/.config/hypr/scripts/gsettings.sh"
        "wl-paste --type text --watch cliphist store" #Stores only text data
        "wl-paste --type image --watch cliphist store" #Stores only image data
        "udiskie & hyprpaper & blueman-applet & fusuma -d & waybar & nm-applet --indicator & mega-cmd"
        "firefox"
        "~/.config/hypr/scripts/batterynotify.sh" # battery notification
        "sudo wgnord c atlanta"
        "tailscale up & tailscale-systray"
        "swayidle -w timeout 600 '~/.config/hypr/scripts/lock.sh' timeout 615 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"

        # THEME THEMING COLORS
        "hyprctl setcursor Bibata-Modern-Ice 20"
        "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'"
        "gsettings set org.gnome.desktop.interface cursor-size 20"
        "kvantummanager --set Catppuccin-Mocha"
        "gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula'"
        "gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha'"
        "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
        "gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'"
        "gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 10'"
        "gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaCove Nerd Font Mono 9'"
        "gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'"
        "gsettings set org.gnome.desktop.interface font-hinting 'full'"
      ];

      # xwayland.force_zero_scaling = true;

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        "eDP-1,highres,0x0,auto"
        "DP-1,highres,0x0,auto"
        "DP-6,highres,1128x0,auto"
        "DP-5,highres,3048x0,auto"
      ];

      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-6, default:true"
        "3, monitor:DP-5, default:true"
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

        follow_mouse = 1;
        sensitivity = 0.5; # -1.0 - 1.0, 0 means no modification.
        force_no_accel = 1;
        touchpad.natural_scroll = "yes";
      };

      general = {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 2;

        # COLORS
        "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        "col.group_border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.group_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        # "col.group_border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        # "col.group_border_locked" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        resize_on_border = true;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        multisample_edges = false;
        drop_shadow = false;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          new_optimizations = true;
        };
      };

      blurls = [
        "waybar"
      ];

      dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
          no_gaps_when_only = false;
      };

      master.new_is_master = false;

      gestures.workspace_swipe = "on";
      gestures.workspace_swipe_fingers = 4;

      "device:logitech-g203-prodigy-gaming-mouse".sensitivity = -0.2;
      "device:pixa3854:00-093a:0274-touchpad".sensitivity = 1.0;

      animations = {
        enabled = "yes";
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      windowrulev2 = [
        "float, title:notification"
        "float, title:dialog"
        "float, title:confirm"
        "float, title:error"
        "float, title:download"
        "float, title:attention"
        "float, title:^(Picture-in-Picture)$"
        "float, title:^(File Operation Progress)$"
        "float, title:^(Confirm to replace files)$"

        "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "size 20% 20%, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "center, class:^(org.kde.polkit-kde-authentication-agent-1)$"

        "float, class:^(blueman-manager)$"
        "float, class:^(trayscale)$"
        "float, class:^(nm-applet)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(pavucontrol)$"

        "size 20% 40%, class:^(org.kde.kcalc)$"
        "float, class:^(org.kde.kcalc)$"

        "idleinhibit fullscreen, class:^(firefox)$"
      ];
    };
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/Wallpapers/pexels-felix-mittermeier-1329917.jpg

    wallpaper = eDP-1,~/Wallpapers/pexels-felix-mittermeier-1329917.jpg
    wallpaper = DP-5,~/Wallpapers/pexels-felix-mittermeier-1329917.jpg
    wallpaper = DP-6,~/Wallpapers/pexels-felix-mittermeier-1329917.jpg
    wallpaper = ,~/Wallpapers/pexels-felix-mittermeier-1329917.jpg
  '';
}




# Window/Session actions
#bind = $mainMod, Q, exec, ~/.config/hypr/scripts/dontkillsteam.sh # killactive, kill the window on focus
#bind = ALT, F4, exec, ~/.config/hypr/scripts/dontkillsteam.sh # killactive, kill the window on focus
#bind = $mainMod, delete, exit, # kill hyperland session
#bind = $mainMod, W, togglefloating, # toggle the window on focus to float
#bind = $mainMod, G, togglegroup, # toggle the window on focus to float

## Screenshot/Screencapture
#bind = $mainMod, P, exec, ~/.config/hypr/scripts/screenshot.sh s # screenshot snip
#bind = $mainMod ALT, P, exec, ~/.config/hypr/scripts/screenshot.sh p # print current screen

## Exec custom scripts
#bind = $mainMod ALT, right, exec, ~/.config/hypr/scripts/swwwallpaper.sh -n # next wallpaper
#bind = $mainMod ALT, left, exec, ~/.config/hypr/scripts/swwwallpaper.sh -p # previous wallpaper
#bind = $mainMod ALT, up, exec, ~/.config/hypr/scripts/wbarconfgen.sh n # next waybar mode
#bind = $mainMod ALT, down, exec, ~/.config/hypr/scripts/wbarconfgen.sh p # previous waybar mode
#bind = $mainMod SHIFT, D, exec, ~/.config/hypr/scripts/togglewallbash.sh  # toggle wallbash on/off
#bind = $mainMod SHIFT, T, exec, pkill rofi || ~/.config/hypr/scripts/themeselect.sh # theme select menu
#bind = $mainMod SHIFT, A, exec, pkill rofi || ~/.config/hypr/scripts/rofiselect.sh # rofi style select menu
#bind = $mainMod SHIFT, W, exec, pkill rofi || ~/.config/hypr/scripts/swwwallselect.sh # rofi wall select menu
#bind = $mainMod, V, exec, pkill rofi || ~/.config/hypr/scripts/cliphist.sh c  # open Pasteboard in screen center

