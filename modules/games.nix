{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # package = pkgs.steam.override {
    #   withPrimus = true;
    #   extraPkgs = pkgs; [ bumblebee glxinfo ];
    # };
  };
  environment.systemPackages = with pkgs; [
    steam-run
    duckstation
    prismlauncher
    protonup-qt
    protontricks
    bottles
    (callPackage ../packages/mtg-forge/default.nix {})
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

