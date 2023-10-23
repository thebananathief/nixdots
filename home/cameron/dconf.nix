{ ... }: {
  # Apparently these are also set via home-manager gtk.*
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # cursor-theme = "Bibata-Modern-Ice";
      cursor-size = 32;
      icon-theme = "Papirus-Dark";
      # gtk-theme = "Catppuccin-Mocha";
      color-scheme = "prefer-dark";
      # font-name = "Lexend 10";
      document-font-name = "Lexend 10";
      monospace-font-name = "JetBrainsMono Nerd Font 10";
      font-antialiasing = "rgba";
      font-hinting = "full";
    };
  };
}
