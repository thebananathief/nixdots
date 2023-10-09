{
  pkgs,
  inputs,
  ...
}:
# games
{
  home.packages = with pkgs; [
    #steam
    prismlauncher
    #protonup-qt
    #protontricks
    #gamescope
    #(lutris.override {extraPkgs = p: [p.libnghttp2];})
  ];
}

