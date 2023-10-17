{ ... }: {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      size = "16x16";
    };
    settings = {
      global = {
        monitor = 0;
        font = "JetBrainsMono 11";
        width = 400;
        height = 150;
        origin = "top-right";
        offset = "24x24";
        scale = 0;
        notification_limit = 5;
        follow = "mouse";
        transparency = 10;

        progress_bar = true;
        progress_bar_height = 10;
      };
      urgency_low = { };
      urgency_normal = { };
      urgency_critical = { };
      # experimental.per_monitor_dpi = true;
    };
  };
}
