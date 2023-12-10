{
  pkgs,
  ...
}:
# games
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  environment.systemPackages = with pkgs; [
    # steam
    prismlauncher
    protonup-qt
    protontricks
    #gamescope
    (lutris.override {
      extraLibraries = pkgs: [
      
      ];
      extraPkgs = pkgs: [
        # p.libnghttp2
      ];
    })
  ];
}

