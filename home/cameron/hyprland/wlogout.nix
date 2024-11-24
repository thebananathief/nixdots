{ globalFonts, ... }:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "waylock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit 0";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "waylock && systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    # The variables in this stylesheet are defined in the logoutlaunch script
    style = ''
* {
    background-image: none;
    font-size: 30px;
}


/* Catppuccin colors */
@import "/nix/store/ix1lvswdllgfpakxfknxrcndph2382x6-mocha.css";

window {
    background-color: rgba(0,0,0,0.5);
}

button {
    color: @text;
    background-color: @main-bg;
    outline-style: none;
    border: none;
    border-width: 0px;
    background-repeat: no-repeat;
    background-position: center;
    background-size: 20%;
    border-radius: 0px;
    box-shadow: none;
    text-shadow: none;
    animation: gradient_f 20s ease-in infinite;
}

button:focus {
    background-color: @wb-act-bg;
    background-size: 30%;
}

button:hover {
    background-color: @mauve;
    background-size: 40%;
    border-radius: 15px;
    animation: gradient_f 20s ease-in infinite;
    transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
}

button:hover#lock {
    border-radius: 15px;
    margin : 10px 0px 10px 10px;
}

button:hover#logout {
    border-radius: 15px;
    margin : 10px 0px 10px 0px;
}

button:hover#suspend {
    border-radius: 15px;
    margin : 10px 0px 10px 0px;
}

button:hover#shutdown {
    border-radius: 15px;
    margin : 10px 0px 10px 0px;
}

button:hover#hibernate {
    border-radius: 15px;
    margin : 10px 0px 10px 0px;
}

button:hover#reboot {
    border-radius: 15px;
    margin : 10px 10px 10px 0px;
}

#lock {
    background-image: image(url("$HOME/.config/wlogout/icons/lock_white.png"), url("/usr/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
    border-radius: 10px 0px 0px 10px;
    margin : 10px 0px 10px 10px;
}

#logout {
    background-image: image(url("$HOME/.config/wlogout/icons/logout_white.png"), url("/usr/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
    border-radius: 0px 0px 0px 0px;
    margin : 10px 0px 10px 0px;
}

#suspend {
    background-image: image(url("$HOME/.config/wlogout/icons/suspend_white.png"), url("/usr/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
    border-radius: 0px 0px 0px 0px;
    margin : 10px 0px 10px 0px;
}

#shutdown {
    background-image: image(url("$HOME/.config/wlogout/icons/shutdown_white.png"), url("/usr/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
    border-radius: 0px 0px 0px 0px;
    margin : 10px 0px 10px 0px;
}

#hibernate {
    background-image: image(url("$HOME/.config/wlogout/icons/hibernate_white.png"), url("/usr/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
    border-radius: 0px 0px 0px 0px;
    margin : 10px 0px 10px 0px;
}

#reboot {
    background-image: image(url("$HOME/.config/wlogout/icons/reboot_white.png"), url("/usr/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
    border-radius: 0px 10px 10px 0px;
    margin : 10px 10px 10px 0px;
}
    '';
  };
}
