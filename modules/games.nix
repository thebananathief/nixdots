{
  pkgs,
  ...
}:
# games
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # package = pkgs.steam.override {
    #   withPrimus = true;
    #   extraPkgs = pkgs; [ bumblebee glxinfo ];
    # };
  };
  environment.systemPackages = 
  with pkgs;
  let 
    mforge = import ../packages/mtg-forge;
  in [
    steam-run
    duckstation
    prismlauncher
    protonup-qt
    protontricks
    bottles
    mforge
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

