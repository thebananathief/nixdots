{ ... }:
{
  services.kanshi = {
    enable = true;
    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "2256x1504@59.99900";
            position = "0,0";
            scale = 1;
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
            scale = 1;
            adaptiveSync = false;
            status = "enable";
          }
          {
            criteria = "DP-5";
            mode = "1920x1080@60.00000Hz";
            position = "1128,0";
            scale = 1;
            adaptiveSync = false;
            status = "enable";
          }
          {
            criteria = "DP-6";
            mode = "1920x1080@60.00000Hz";
            position = "3048,0";
            scale = 1;
            adaptiveSync = false;
            status = "enable";
          }
          {
            criteria = "DP-7";
            mode = "1920x1080@60.00000Hz";
            position = "1128,0";
            scale = 1;
            adaptiveSync = false;
            status = "enable";
          }
          {
            criteria = "DP-8";
            mode = "1920x1080@60.00000Hz";
            position = "3048,0";
            scale = 1;
            adaptiveSync = false;
            status = "enable";
          }
        ];
      };
    };
  };
}
