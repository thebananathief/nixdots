{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ranger
    fzf
    broot
    nnn
    lf
    pistol
  ];
}
