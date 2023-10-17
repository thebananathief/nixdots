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
  };
}
