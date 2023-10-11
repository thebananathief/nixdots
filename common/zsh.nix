{ config, lib, pkgs, ... }: {
  environment.shells = [ pkgs.zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "avit";
      plugins = [
        # "git"
        "git-auto-fetch"
        "sudo"
        "fzf"
      ];
    };
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
  };

  environment.systemPackages = with pkgs; [ fzf ];
}
