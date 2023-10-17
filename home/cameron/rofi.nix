{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    font = "Lexend 14";
    plugins = with pkgs; [
      rofi-calc
      rofi-vpn
      rofi-bluetooth
      rofi-file-browser
      rofi-rbw
      rofi-wayland
    ];
  };
}
