{ pkgs, globalFonts, nix-colors, lib, config, ... }: rec {
  home.packages = with pkgs; [
    gsettings-qt
    gsettings-desktop-schemas
    dconf-editor
  ];

  fonts.fontconfig.enable = true;

#   home.pointerCursor = {
#     name = "Bibata-Modern-Ice";
#     package = pkgs.bibata-cursors;
#     size = 24;
#     gtk.enable = true;
#   };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    font = {
      name = "${globalFonts.sansSerif}";
      # package = pkgs.lexend;
      size = 10;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;

    gtk3.extraCss = ''
      .nautilus-list-view listview row { margin: 0px; padding: 0; }
      .nautilus-list-view #NautilusViewCell { padding: 0px; }
    '';
    gtk4.extraCss = ''
      .nautilus-list-view listview row { margin: 0px; padding: 0; }
      .nautilus-list-view #NautilusViewCell { padding: 0px; }
    '';
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/mutter" = {
        experimental-features = "scale-monitor-framebuffer";
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        # document-font-name = "${globalFonts.sansSerif} 10";
        # monospace-font-name = "${globalFonts.monospace} 10";
      };
    };
  };

#   programs.bat.config.theme = "Catppuccin-mocha";

  # Make home-manager stop nagging about overwriting these files
  home.file.${config.gtk.gtk2.configLocation}.force = true;
  xdg = {
    configFile."gtk-3.0/gtk.css".force = true;
    configFile."gtk-3.0/settings.ini".force = true;
    configFile."gtk-4.0/gtk.css".force = true;
    configFile."gtk-4.0/settings.ini".force = true;

    # configFile."Kvantum/GraphiteNord".source = "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
    # configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
    #   General.theme = "Catppuccin-Mocha-Blue";
    # };
    # configFile."Kvantum/kvantum.kvconfig".text = ''
    #   [General]
    #   theme=GraphiteNordDark
    # '';
  };

}
