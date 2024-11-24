{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    font = "Lexend 14";
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [
      rofi-calc
      rofi-vpn
      rofi-bluetooth
      rofi-file-browser
      rofi-rbw
    ];
    theme = "glue_pro_blue";
    extraConfig = {
      modi = "drun,ssh";
      kb-primary-paste = "Control+V,Shift+Insert";
      kb-secondary-paste = "Control+v,Insert";
    };
  };
}
