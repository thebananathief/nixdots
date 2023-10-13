{ pkgs  ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      layer = "top";
      position = "top";
      mod = "dock";
      height = 35;
      exclusive = true;
      passthrough = false;
      gtk-layer-shell = true;

      modules-left = ["custom/padd" "custom/l_end" "custom/power" "custom/cliphist" "custom/wbar" "custom/mode" "custom/wallchange" "custom/r_end" "custom/l_end" "custom/spotify" "custom/r_end" "" "custom/padd"];
      modules-center = ["custom/padd" "custom/l_end" "idle_inhibitor" "wlr/taskbar" "clock" "custom/r_end" "custom/padd"];
      modules-right = ["custom/padd" "custom/l_end" "tray" "custom/r_end" "custom/l_end" "battery" "network" "bluetooth" "pulseaudio" "pulseaudio#microphone" "custom/r_end" "custom/padd"];

      "custom/power" = {
        format = "{}";
        exec = "echo ; echo  logout";
        on-click = "~/.config/hypr/scripts/logoutlaunch.sh 2";
        interval = 86400;
        tooltip = true;
      };

      "wlr/taskbar" = {
        format = "{icon}";
        icon-size = 18;
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

      "custom/playback" = {
        format = "{} ";
        on-click = "playerctl play-pause --player spotify";
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
        exec = "/usr/bin/python3 /home/tittu/.config/waybar/modules/mediaplayer.py --player spotify";
        return-type = "json";
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons.activated = "󰥔";
        format-icons.deactivated = "";
      };

      "clock" = {
        format = "{:%I:%M %p 󰃭 %a %d}";
        format-alt = "{:%H:%M  %b %Y}";
        tooltip-format = "<tt><big>{calendar}</big></tt>";
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
        format-icons = [ "󰂎" "󰁺" "󰁻"  "󰁼"  "󰁽"  "󰁾"  "󰁿"  "󰂀"  "󰂁"  "󰂂"  "󰁹" ];
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
        on-click-middle = "~/.config/hypr/scripts/volumecontrol.sh -o m";
        on-scroll-up = "~/.config/hypr/scripts/volumecontrol.sh -o i";
        on-scroll-down = "~/.config/hypr/scripts/volumecontrol.sh -o d";
        tooltip-format = "{icon} {desc} // {volume}%";
        scroll-step = 5;
        format-icons = [
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["", "", ""];
        ];
      };

      "pulseaudio#microphone" = {
        format = "{format_source}";
        format-source = "";
        format-source-muted = "";
        on-click = "pavucontrol -t 4";
        on-click-middle = "~/.config/hypr/scripts/volumecontrol.sh -i m";
        on-scroll-up = "~/.config/hypr/scripts/volumecontrol.sh -i i";
        on-scroll-down = "~/.config/hypr/scripts/volumecontrol.sh -i d";
        tooltip-format = "{format_source} {source_desc} // {source_volume}%";
        scroll-step = 5;
      };

      "custom/l_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/r_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/sl_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/sr_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/rl_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/rr_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/padd" = {
        format = "  ";
        interval = "once";
        tooltip = false;
      };
    };
    style = ''
* {
    border: none;
    border-radius: 0px;
    font-family: "M+2 Nerd Font";
    font-weight: bold;
    font-size: 14px;
    min-height: 12px;
}

@import "${fetchUrl "https://raw.githubusercontent.com/catppuccin/waybar/main/themes/mocha.css"}";

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
    padding-left: 3px;
    padding-right: 3px;
    color: @wb-color;
    animation: gradient_f 20s ease-in infinite;
    transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
}

#taskbar button.active {
    background: @wb-act-bg;
    color: @wb-act-color;
    /*margin-left: 3px;*/
    /*padding-left: 12px;*/
    /*padding-right: 12px;*/
    /*margin-right: 3px;*/
    animation: gradient_f 20s ease-in infinite;
    transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
}

#taskbar button:hover {
    background: @wb-hvr-bg;
    color: @wb-hvr-color;
    /*padding-left: 3px;*/
    /*padding-right: 3px;*/
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

#custom-r_end {
    border-radius: 0px 21px 21px 0px;
    margin-right: 9px;
    padding-right: 3px;
}

#custom-l_end {
    border-radius: 21px 0px 0px 21px;
    margin-left: 9px;
    padding-left: 3px;
}

#custom-sr_end {
    border-radius: 0px;
    margin-right: 9px;
    padding-right: 3px;
}

#custom-sl_end {
    border-radius: 0px;
    margin-left: 9px;
    padding-left: 3px;
}

#custom-rr_end {
    border-radius: 0px 7px 7px 0px;
    margin-right: 9px;
    padding-right: 3px;
}

#custom-rl_end {
    border-radius: 7px 0px 0px 7px;
    margin-left: 9px;
    padding-left: 3px;
}
'';
  };
}
