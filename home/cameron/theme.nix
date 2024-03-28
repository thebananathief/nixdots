{ pkgs, globalFonts, nix-colors, lib, ... }: rec {
  imports = [
    ./spicetify.nix
    # nix-colors.homeManagerModules.default
  ];

  # https://www.youtube.com/watch?v=jO2o0IN0LPE for help
  # colorScheme = nix-colors.colorSchemes.brogrammer;

  home.packages = with pkgs; [
    gsettings-qt
    gsettings-desktop-schemas
    gnome.dconf-editor
    nwg-look
    
    papirus-icon-theme
  ];

  # https://www.youtube.com/watch?v=m_6eqpKrtxk theming help
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
    # platformTheme = "qtct";
    platformTheme = "gtk3";
    # style.name = "gtk2";
    style.name = "breeze";
    # style.package = pkgs.libsForQt5.breeze-qt5;
  };

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = lib.mkForce "breeze-dark";
    # QT_QPA_PLATFORMTHEME = "";
  };
  systemd.user.sessionVariables = home.sessionVariables;

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
      name = "Breeze-Dark";
      package = pkgs.libsForQt5.breeze-gtk;
      # name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      # package = pkgs.catppuccin-gtk.override {
      #   variant = "mocha";
      #   accents = ["mauve"];
      #   size = "compact";
      # };
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
    
  # Make home-manager stop nagging about overwriting these files
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
