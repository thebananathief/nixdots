{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    eza
  ];

  programs.yazi = {
    enable = true;
  };
}
