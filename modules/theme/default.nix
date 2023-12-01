{ pkgs, ... }: {
  imports = [
    ./fonts.nix
  ];

  # make HM-managed GTK stuff work
  programs.dconf.enable = true;

  qt.enable = true;
  qt.platformTheme = "qt5ct";
  # qt.style = "adwaita-dark";

  environment = {
    # sessionVariables = {
    #   GTK_THEME = "Catppuccin-Mocha-Compact-Mauve-Dark";
    #   GDK_SCALE = "1";
    #   # XCURSOR_SIZE = "32";
    #   # XCURSOR_THEME = "Bibata-Modern-Ice";
    # };
    systemPackages = with pkgs; [
      # This package configures the kvantum one
      # (catppuccin.override {
      #   accent = "mauve";
      #   variant = "mocha";
      # })
      (catppuccin-kvantum.override {
        accent = "Mauve";
        variant = "Mocha";
      })
      (catppuccin-gtk.override {
        variant = "mocha";
        accents = ["mauve"];
      })
      (catppuccin-kde.override {
        flavour = ["mocha"];
        accents = ["mauve"];
      })
      # (catppuccin-papirus-folders.override {
      #   flavor = "mocha";
      #   accent = "mauve";
      # })
      # papirus-icon-theme
      catppuccin-cursors.mochaMauve
      bibata-cursors
      libsForQt5.breeze-grub

      gsettings-qt
      gsettings-desktop-schemas
      gnome.dconf-editor
      xsettingsd
      
    # GUI Styling apps
      # qtct apps are through the nixos qt.nix module
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
      nwg-look
    ];
  };
}
