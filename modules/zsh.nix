{ config, lib, pkgs, ... }: {
  environment = {
    # systemPackages = with pkgs; [
    #
    # ];
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/share/zsh" ];
  };
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git-auto-fetch"
        "sudo"
      ];
    };
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;
}
