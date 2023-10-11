{
  pkgs,
  ...
}:
# games
{
  environment.systemPackages = with pkgs; [
    steam
    prismlauncher
    protonup-qt
    protontricks
    #gamescope
    #(lutris.override {extraPkgs = p: [p.libnghttp2];})
  ];
}

