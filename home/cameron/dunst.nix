{ ... }: {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Tela-circle-dracula";
      # package = pkgs.;
      size = "16x16";
    };
    settings = {
      global = {
        monitor = 0;
        font = "JetbrainsMono 12";
        width = 300;
        height = 200;
        origin = "top-right";
        offset = "24x24";
        scale = 0;
        notification_limit = 5;
        follow = "mouse";
        transparency = 10;
        
        progress_bar = true;
        progress_bar_height = 10;
      };
      urgency_low = {
      };
      urgency_normal = {
      };
      urgency_critical = {
      };
      # experimental.per_monitor_dpi = true;
    };
  };
}
