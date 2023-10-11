{ pkgs, ... }: {
  imports = [
    ./fonts.nix
  ];

  # make HM-managed GTK stuff work
  programs.dconf.enable = true;

  qt.enable = true;
  qt.style = "kvantum";
  qt.platformTheme = "qt5ct";

  environment = {
    sessionVariables = {
      # QT_QPA_PLATFORMTHEME = "qt5ct";
      # QT_STYLE_OVERRIDE = "kvantum";
      GTK_THEME = "Catppuccin-Mocha-Compact-Mauve-Dark";
      XCURSOR_SIZE = "24";
      XCURSOR_THEME = "Bibata-Modern-Ice 24";
    };
    systemPackages = with pkgs; [
      catppuccin-kvantum
      catppuccin-cursors
      (catppuccin-gtk.override {
        accents = ["mauve"];
        size = "compact";
        variant = "mocha";
      })
      #catppuccin-kde
      #tela-icon-theme
      bibata-cursors
      papirus-icon-theme

      gsettings-qt
      gsettings-desktop-schemas
      gnome.dconf-editor
      xsettingsd
      fontconfig
      fontfor
      
      fontpreview
      libsForQt5.breeze-grub
      nwg-look
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      qt6Packages.qt6ct
    ];
  };
}