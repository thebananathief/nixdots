{ config, lib, pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [ fzf zsh-fzf-tab ];
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/share/zsh" ];
  };
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
}
