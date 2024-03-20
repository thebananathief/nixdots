{ ... }: 
let
  theme = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/alacritty/main/catppuccin-mocha.toml";
    sha256 = "061yalrzpqivr67k2f8hsqixr77srgd8y47xvhp5vg0sjmh5lrcy";
  };
in {
  programs.alacritty = {
    enable = true;
    settings = {
      "import" = [
        theme
      ];
      font = let family = "JetBrainsMono Nerd Font";
      in {
        size = 10;
        normal.family = family;
        normal.style = "Regular";
        italic.family = family;
        italic.style = "Italic";
        bold.family = family;
        bold.style = "Bold";
        bold_italic.family = family;
        bold_italic.style = "Bold Italic";
        antialias = true;
        autohint = true;
      };
      window = {
        opacity = 0.8;
        padding.x = 2;
        padding.y = 2;
      };
      cursor.style = "Beam";
      cursor.vi_mode_style = "Block";
      scrolling = {
        history = 10000;
        multiplier = 3;
        auto_scroll = false;
      };
      hints = {
        alphabet = "jfkdls;ahgurieowpq";
        enabled = [
          {
            regex = "(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|http[s]:|news:|file:|git:|ssh:|ftp:)[^\\u0000-\\u001F\\u007F-\\u009F<>\"\\\\s{-}\\\\^⟨⟩`]+";
            hyperlinks = true;
            command = "xdg-open";
            post_processing = true;
            mouse.enabled = true;
            mouse.mods = "Control";
            binding.key = "U";
            binding.mods = "Control|Shift";
          }
        ];
      };
    };
  };
}
