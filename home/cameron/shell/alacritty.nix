{ globalFonts, ... }:
let
#  theme = builtins.fetchurl {
#    url = "https://raw.githubusercontent.com/catppuccin/alacritty/main/catppuccin-mocha.toml";
#    sha256 = "1rnc6gsqjdvkb6xbv1pnawrp6f0j5770dqml2di90j3lhv0fppgw";
#  };
in {
  programs.alacritty = {
    enable = true;
    settings = {
#      "import" = [
#        theme
#      ];
      font = let family = globalFonts.monospace;
      in {
        size = 9;
        normal.family = family;
        normal.style = "Regular";
        italic.family = family;
        italic.style = "Italic";
        bold.family = family;
        bold.style = "Bold";
        bold_italic.family = family;
        bold_italic.style = "Bold Italic";
      };
      window = {
        opacity = 0.85;
        padding.x = 2;
        padding.y = 2;
      };
      cursor.style = "Beam";
      cursor.vi_mode_style = "Block";
      scrolling = {
        history = 10000;
        multiplier = 3;
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
  
  dconf.settings = {
    "org/cinnamon/desktop/applications/terminal".exec = "alacritty";
  };
}
