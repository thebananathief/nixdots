{ pkgs, ... }: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      grace = 5;
      fade-in = 1;
      clock = true;
      screenshots = true;
      indicator = true;
      indicator-radius = 160;
      indicator-thickness = 9;
      effect-blur = "9x9";
      effect-vignette = "0.5:0.5";
      font = "FiraCode Nerd Font:style=Regular 32";
      ignore-empty-password = true;
    };
  };
}
