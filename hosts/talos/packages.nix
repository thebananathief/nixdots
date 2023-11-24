{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
  ## CLI
    neofetch
    btop
    ethtool
    just
    universal-ctags
    dos2unix
    tldr
    dua
    #cut

  ## Coding
    zig
    go
    nodejs-slim
    rustup
    jsonfmt

  ## General desktop
    megacmd
  ];
}
