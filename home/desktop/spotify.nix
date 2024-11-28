{ pkgs, lib, ... }:
# let
#   spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
# in
{
  # import the flake's module for your system
  # imports = [ spicetify-nix.homeManagerModule ];

  home.packages = with pkgs; [
    # spicetify-cli
    spotify
  ];
  
  # https://github.com/the-argus/spicetify-nix
  # programs.spicetify = {
  #   enable = true;
  #   theme = spicePkgs.themes.catppuccin;
  #   colorScheme = "mocha";

  #   enabledExtensions = with spicePkgs.extensions; [
  #     fullAppDisplay
  #     shuffle # shuffle+ (special characters are sanitized out of ext names)
  #     hidePodcasts

  #     # playlistIcons
  #     # lastfm
  #     # genre
  #     # historyShortcut
  #   ];
  # };
}
