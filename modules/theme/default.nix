{ pkgs, ... }: {
  imports = [
    ./fonts.nix
  ];

  # make HM-managed GTK stuff work
  programs.dconf.enable = true;

  qt.enable = true;
  qt.platformTheme = "qt5ct";
  qt.style = "kvantum";

  environment = {
    systemPackages = with pkgs; [
      # This package configures a bunch of smaller programs, but its unstable atm
      # (catppuccin.override {
      #   accent = "mauve";
      #   variant = "mocha";
      # })
      (catppuccin-kvantum.override {
        accent = "Mauve";
        variant = "Mocha";
      })
      # (catppuccin-gtk.override {
      #   variant = "mocha";
      #   accents = ["mauve"];
      # })
      (catppuccin-kde.override {
        flavour = ["mocha"];
        accents = ["mauve"];
      })
      # (catppuccin-papirus-folders.override {
      #   flavor = "mocha";
      #   accent = "mauve";
      # })
      # papirus-icon-theme
      # catppuccin-cursors.mochaMauve
      # bibata-cursors
      # libsForQt5.breeze-grub

      gsettings-qt
      gsettings-desktop-schemas
      gnome.dconf-editor
      xsettingsd
      nwg-look
    ];
  };
}
