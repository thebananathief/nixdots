{ pkgs, ... }: {
  import = [
    ../../modules/desktops/gnome.nix
  ];

  # enable location service
  # location.provider = "geoclue2";

  programs.ssh.startAgent = true;

#   Enable sound with pipewire.
#  hardware.pulseaudio.enable = false;
#  hardware.bluetooth.enable = true;
#  sound.enable = true;
#  services.pipewire = {
#    enable = true;
#    alsa.enable = true;
#    alsa.support32Bit = true;
#    pulse.enable = true;
#    jack.enable = true; # only used for MIDI stuff i think
#  };



  # Configure X11, desktop, and keymap
  # services.xserver = {
  #   enable = true;
  #   layout = "us";
  #   xkbVariant = "";
  #   desktopManager.xterm.enable = false;

  #   displayManager = {
  #     defaultSession = "hyprland";
  #     gdm.enable = true;
  #     gdm.wayland = true;
  #   };

  #   libinput = {
  #     enable = true;
  #     touchpad = {
  #       accelProfile = "flat";
  #       accelSpeed = "0.5";
  #       naturalScrolling = false;
  #     };
  #     mouse = {
  #       accelProfile = "flat";
  #       accelSpeed = "1.0";
  #       naturalScrolling = false;
  #     };
  #   };
  # };

  # xdg.portal = {
  #   enable = true;
  #   xdgOpenUsePortal = true;
  #   wlr.enable = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-wlr
  #     xdg-desktop-portal-gtk
  #     # xdg-desktop-portal-xapp
  #     # libsForQt5.xdg-desktop-portal-kde
  #     # xdg-desktop-portal-gnome
  #     # lxqt.xdg-desktop-portal-lxqt
  #   ];
  # };
}
