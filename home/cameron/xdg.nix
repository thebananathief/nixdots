{ config, ... }: {
  xdg = {
    enable = true;

    # cacheHome = config.home.homeDirectory + "/.local/cache";

    mimeApps = {
      enable = true;
      defaultApplications = let
        browser = [ "firefox.desktop" ];
        editTerminal = [ "edit.desktop" ];
      in {
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/xhtml+xml" = browser;
        "application/xhtml_xml" = browser;
        "application/json" = browser;
        
        "text/html" = browser;
        "text/xml" = browser;
        
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/chrome" = [ "chromium-browser.desktop" ];
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/unknown" = browser;
        
        "application/x-shellscript" = editTerminal;
        "application/x-trash" = editTerminal;
        "application/x-zerosize" = editTerminal;
        "application/rss+xml" = browser;
        "application/rdf+xml" = browser;
        "application/xml" = browser;
        "text/plain" = editTerminal;

        "x-scheme-handler/discord" = ["discord.desktop"];
        "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
        "x-scheme-handler/spotify" = [ "spotify.desktop" ];
        "application/pdf" = [ "org.pwmt.zathura.desktop.desktop" ];
        "inode/directory" = [ "thunar.desktop" ];

        "audio/*" = [ "mpv.desktop" ];
        "video/*" = [ "mpv.dekstop" ];
        "image/*" = [ "imv.desktop" ];
        "text/*" = editTerminal;
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      # extraConfig = {
      #   XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      # };
    };

    desktopEntries."edit" = {
      name = "Edit w/ Neovim";
      genericName = "Text Editor";
      comment = "Open the file in neovim on top of alacritty";
      icon = "nvim";
      terminal = true;
      exec = "nvim %f";
      #exec = "${pkgs.alacritty}/bin/alacritty --command nvim";
      type = "Application";
      mimeType = [ "text/plain" ];
      categories = [ "TextEditor" "Utility" ];
    };
  };
}

