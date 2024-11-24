{ config, ... }: {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = config.gtk.iconTheme.name; #"Papirus-Dark";
      package = config.gtk.iconTheme.package; #pkgs.papirus-icon-theme;
      size = "24x24";
    };
    settings = {
      global = {
        font = "Hack Code Nerd Font 12";
        follow = "mouse";
        transparency = 10;
        notification_limit = 5;
        indicate_hidden = true;
        
        monitor = 0;
        scale = 0;
        origin = "top-right";
        offset = "24x24";
        
        corner_radius = 10;
        width = 400;
        height = 150;
        frame_width = 3;
        gap_size = 5;
        padding = 12;
        horizontal_padding = 16;
        text_icon_padding = 10;
        line_height = 0;
        
        markup = "full";
        format = "󰟪 %a\\n<b>󰋑 %s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";

        show_age_threshold = 60;
        ellipsize = "middle";

        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        
        icon_corner_radius = 5;
        icon_theme = config.gtk.iconTheme.name;
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;
        # icon_path = ""; # maybe not needed

        sticky_history = true;
        history_length = 20;
        
        dmenu = "anyrun --plugins stdin";
        browser = "handlr open";
        always_run_script = true;

        title = "Dunst";
        class = "Dunst";

        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        
        mouse_left_click = "context, close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
        
        separator_height = 2;
        # separator_color
        #  * auto: dunst tries to find a color fitting to the background;
        #  * foreground: use the same color as the foreground;
        #  * frame: use the same color as the frame;
        #  * anything else will be interpreted as a X color.
        separator_color = "auto";

        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 125;
        progress_bar_max_width = 250;
        progress_bar_corner_radius = 4;
      };
      experimental.per_monitor_dpi = true;
      urgency_low = {
        background = "#181825";
        foreground = "#f5e0dc";
        frame_color = "#f5c2e7";
        icon = "~/.config/dunst/icons/low.svg";
        timeout = 10;
      };
      urgency_normal = {
        background = "#313244";
        foreground = "#f5e0dc";
        frame_color = "#b4befe";
        icon = "~/.config/dunst/icons/pokeball.svg";
        timeout = 10;
      };
      urgency_critical = {
        background = "#f5e0dc";
        foreground = "#1e1e2e";
        frame_color = "#f38ba8";
        icon = "~/.config/dunst/icons/critical.svg";
        # Show until the user dismisses
        timeout = 0;
      };
      volume-control = {
        summary = "volctl";
        format = "<span size=\"250%\">%a</span>\\n%b";
      };
      brightness-control = {
        summary = "brightctl";
        format = "<span size=\"250%\">%a</span>\\n%b";
      };
    };
  };
}
