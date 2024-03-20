{ ... }:
{
  services.kanshi = {
    enable = true;
    # Required for hyprland (kanshi is originally for sway)
    systemdTarget = "hyprland-session.target";

    profiles = {
      desktop = {
        outputs = [
          {
            criteria = "DP-2";
            mode = "1920x1080@60.00000";
            position = "0,0";
            scale = 1.0;
            adaptiveSync = false;
            status = "enable";
          }
          {
            criteria = "DP-3";
            mode = "1920x1080@60.00000";
            position = "0,-1080";
            scale = 1.0;
            adaptiveSync = false;
            status = "enable";
          }
          {
            criteria = "DP-1";
            mode = "1920x1080@60.00000";
            position = "1920,-200";
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
