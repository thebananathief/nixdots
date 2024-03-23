{ pkgs, lib, inputs, globalFonts, nix-colors, ... }: rec {
  inputs = [
    nix-colors.homeManagerModules.default
  ];

  # https://www.youtube.com/watch?v=jO2o0IN0LPE for help
  # colorScheme = nix-colors.colorSchemes.brogrammer;

  fonts.fontconfig.enable = true;
  
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    # name = "Catppuccin-Mocha-Mauve";
    # package = pkgs.catppuccin-cursors.mochaMauve;
    size = 24;
    gtk.enable = true;
    # x11.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };

  gtk = {
    enable = true;
    font = {
      name = "${globalFonts.sansSerif}";
      # package = pkgs.lexend;
      size = 10;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = ["mauve"];
        size = "compact";
      };
    };

    gtk3.extraCss = ''
      .nautilus-list-view listview row { margin: 0px; padding: 0; }
      .nautilus-list-view #NautilusViewCell { padding: 0px; }
    '';
    gtk4.extraCss = ''
      .nautilus-list-view listview row { margin: 0px; padding: 0; }
      .nautilus-list-view #NautilusViewCell { padding: 0px; }
    '';
  };

  home.sessionVariables = {
    # GDK_SCALE = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # QT_FONT_DPI = "1";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      document-font-name = "${globalFonts.sansSerif} 10";
      monospace-font-name = "${globalFonts.monospace} 10";
      # font-antialiasing = "rgba";
      # font-hinting = "full";
    };
  };

  programs.bat.config.theme = "Catppuccin-mocha";

#   xdg.configFile."bat/themes/Catppuccin-mocha.tmTheme".source = pkgs.fetchurl {
#     url = "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme";
#     sha256 = "a8c40d2466489a68ebab3cbb222124639221bcf00c669ab45bab242cbb2783fc";
#   };
}
