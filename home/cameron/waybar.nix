{globalFonts, ...}: let
  colors = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/waybar/main/themes/mocha.css";
    sha256 = "15bqhwfli7vsjc8c9i0a8a5jl9nd44wa209pvn2g8danwc6ic8xy";
  };
in {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        mod = "dock";
        # height = 35;
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        # desktop
        # output = "HDMI-A-1";
        # laptop
        # output = "DP-5";

        modules-left = [
          "custom/power"
          "battery"
          "hyprland/window"
          # "custom/cliphist"
          # "custom/wbar"
          # "custom/mode"
          # "custom/wallchange"
          # "custom/spotify"
        ];
        modules-center = [
          # "idle_inhibitor"
          "wlr/taskbar"
          # "hyprland/workspaces"
        ];
        modules-right = [
          "tray"
          "network"
          # "bluetooth"
          "pulseaudio"
          "pulseaudio#microphone"
          "clock"
        ];

        "custom/power" = {
          format = "{}";
          exec = "echo ; echo  logout";
          on-click = "~/github/nixdots/scripts/logoutlaunch";
          interval = 86400;
          tooltip = true;
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 20;
          icon-theme = "Tela-circle-dracula";
          spacing = 0;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
          ignore-list = [
            "Alacritty"
          ];
          app_ids-mapping = {
            firefoxdeveloperedition = "firefox-developer-edition";
          };
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "custom/playback" = {
          format = "{} ";
          on-click = "playerctl play-pause --player spotify";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
          # exec is the tooltip display i think
          # exec = "~/github/nixdots/scripts/spotifyvolumecontrol";
          return-type = "json";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons.activated = "󰥔";
          format-icons.deactivated = "";
        };

        "clock" = {
          format = "{:%I:%M %p  %Y-%m-%d}";
          # format = "{:%I:%M %p 󰃭 %a %d}";
          # format-alt = "{:%H:%M  %b %Y}";
          tooltip-format = "<tt><big>{calendar}</big></tt>";
          calendar = {
            mode = "year";
            # mode-mon-col = 3;
            # weeks-pos = "right";
            # on-scroll = 1;
            # on-click-right = "mode";
          };
        };

        "tray" = {
          icon-size = 18;
          spacing = 5;
        };

        "battery" = {
          states.good = 95;
          states.warning = 30;
          states.critical = 20;
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        "network" = {
          format-wifi = "󰤨 {essid}";
          format-ethernet = "󱘖 Wired";
          format-linked = "󱘖 {ifname} (No IP)";
          format-disconnected = " Disconnected";
          format-alt = "󰤨 {signalStrength}%";
          interval = 5;
          tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
        };

        "bluetooth" = {
          format = "";
          format-disabled = "";
          format-connected = " {num_connections}";
          tooltip-format = " {device_alias}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = " {device_alias}";
        };

        "pulseaudio" = {
          format = "{icon} {volume}";
          format-muted = "婢";
          on-click = "pavucontrol -t 3";
          on-click-middle = "~/github/nixdots/scripts/volumecontrol -o m";
          on-scroll-up = "~/github/nixdots/scripts/volumecontrol -o i";
          on-scroll-down = "~/github/nixdots/scripts/volumecontrol -o d";
          tooltip-format = "{icon} {desc} // {volume}%";
          scroll-step = 5;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "";
          format-source-muted = "";
          on-click = "pavucontrol -t 4";
          on-click-middle = "~/github/nixdots/scripts/volumecontrol -i m";
          on-scroll-up = "~/github/nixdots/scripts/volumecontrol -i i";
          on-scroll-down = "~/github/nixdots/scripts/volumecontrol -i d";
          tooltip-format = "{format_source} {source_desc} // {source_volume}%";
          scroll-step = 5;
        };
      };
    };

    style = ''
      * {
          border: none;
          border-radius: 0px;
          font-family: "${globalFonts.prettyNerd}";
          font-weight: bold;
          font-size: 14px;
          min-height: 12px;
      }

      @import "${colors}";

      window#waybar {
          background: @bar-bg;
      }

      tooltip {
          background: @main-bg;
          color: @main-fg;
          border-radius: 7px;
          border-width: 0px;
      }

      #workspaces button {
          box-shadow: none;
          text-shadow: none;
          padding: 0px;
          border-radius: 9px;
          margin-top: 3px;
          margin-bottom: 3px;
          padding-left: 3px;
          padding-right: 3px;
          color: @main-fg;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #workspaces button.active {
          background: @wb-act-bg;
          color: @wb-act-fg;
          margin-left: 3px;
          padding-left: 12px;
          padding-right: 12px;
          margin-right: 3px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #workspaces button:hover {
          background: @wb-hvr-bg;
          color: @wb-hvr-fg;
          padding-left: 3px;
          padding-right: 3px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #taskbar button {
          box-shadow: none;
          text-shadow: none;
          padding: 0px;
          border-radius: 9px;
          margin-top: 3px;
          margin-bottom: 3px;
          padding-left: 1px;
          padding-right: 1px;
          color: @wb-color;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #taskbar button.active {
          background: @wb-act-bg;
          color: @wb-act-color;
          margin-left: 3px;
          padding-left: 12px;
          padding-right: 12px;
          margin-right: 3px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #taskbar button:hover {
          background: @wb-hvr-bg;
          color: @wb-hvr-color;
          padding-left: 1px;
          padding-right: 1px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #battery,
      #bluetooth,
      #custom-cliphist,
      #clock,
      #cpu,
      #custom-gpuinfo,
      #idle_inhibitor,
      #memory,
      #custom-mode,
      #mpris,
      #network,
      #custom-power,
      #pulseaudio,
      #custom-spotify,
      #taskbar,
      #tray,
      #custom-updates,
      #custom-wallchange,
      #custom-wbar,
      #window,
      #workspaces,
      #custom-l_end,
      #custom-r_end,
      #custom-sl_end,
      #custom-sr_end,
      #custom-rl_end,
      #custom-rr_end {
          color: @main-fg;
          background: @main-bg;
          opacity: 1;
          margin: 4px 0px 4px 0px;
          padding-left: 4px;
          padding-right: 4px;
      }

      #workspaces,
      #taskbar {
          padding: 0px;
      }
    '';
  };
}
