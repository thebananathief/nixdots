{ config, ... }: {
  imports = [
    ./options.nix
    ./indexer.nix
    # ./books.nix
    ./jellyfin.nix
    ./download.nix
  ];
}