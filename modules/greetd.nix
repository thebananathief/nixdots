{
  lib,
  pkgs,
  config,
  default,
  ...
}:
# greetd display mngr
let
  greetdHyprConfig = pkgs.writeText "greetd-hypr-config" ''

  '';
in {
  services = {
    greetd.enable = true;
    greetd.settings = {
      default_session = {
        command = "${pkgs.sway}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  programs = {
    regreet = {
      enable = true;
      settings = {
        commands = {
          reboot = [ "systemctl" "reboot" ];
          poweroff = [ "systemctl" "poweroff" ];
        };
        GTK = {
          application_prefer_dark_theme = true;
          cursor_theme_name = "Bibata-Modern-Ice";
          icon_theme_name = "Papirus-Dark";
          theme_name = "Catppuccin-Mocha-Compact-Mauve-Dark";
          font_name = "Arimo Nerd Font 15";
        };
        #background.path = "/home/cameron/Wallpapers/shot-by-cerqueira-0o_GEzyargo-unsplash.jpg";
        #background.fit = "Cover";
      };
    };
  };
};
