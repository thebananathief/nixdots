{ config, ... }: {
  imports = [
    ./indexer.nix
    # ./books.nix
    ./jellyfin.nix
    ./download.nix
  ];
}