{ lib, config, ... }:
{
  services.kanshi = {
    enable = true;
    
    # Supposedly required for hyprland (kanshi is originally for sway), BUT, I found that it gave errors
    # when you run kanshictl reload, unless you leave this as sway and start kanshi through the hyprland config instead!
    # systemdTarget = lib.mkIf config.wayland.windowManager.hyprland.enable "hyprland-session.target";
    # systemdTarget = "hyprland-session.target";

    profiles = {
      desktop = {
        outputs = [
          # main bottom
          {
            criteria = "AOC 27G15 AH15332Z02974";
            mode = "1920x1080@180";
            position = "0,0";
            transform = "normal";
            scale = 1.0;
            adaptiveSync = true;
            status = "enable";
          }
          # main top
          {
            criteria = "AOC 27G15 AH15332Z02979";
            mode = "1920x1080@180";
            position = "0,-1080";
            transform = "normal";
            scale = 1.0;
            adaptiveSync = true;
            status = "enable";
          }
          # vertical
          {
            criteria = "Lenovo Group Limited D27-30 URHHM364";
            mode = "1920x1080@75";
            position = "1920,-500";
            transform = "90";
            scale = 1.0;
            adaptiveSync = false;
            status = "enable";
          }
        ];
      };
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "2256x1504@59.99900";
            position = "0,0";
            scale = 2.0;
            adaptiveSync = false;
            status = "enable";
          }
        ];
      };
      docked = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "2256x1504@59.99900Hz";
            position = "0,0";
            scale = 2.0;
            adaptiveSync = false;
            status = "enable";
          }
          {
            criteria = "HP Inc. HP V24 1CR0440LFS";
            mode = "1920x1080@60.00000Hz";
            position = "1128,0";
            scale = 1.0;
            adaptiveSync = false;
            status = "enable";
          }
          {
            criteria = "HP Inc. HP V214a CNC7160VL4";
            mode = "1920x1080@60.00000Hz";
            position = "3048,0";
            scale = 1.0;
            adaptiveSync = false;
            status = "enable";
          }
        ];
      };
    };
  };
}
