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
      theme = "avit";
      plugins = [
        "git-auto-fetch"
        "sudo"
      ];
    };
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      edit = "$EDITOR";
      e = "$EDITOR";
      nic = "edit ~/github/nixdots";
      vic = "edit ~/github/dotfiles/.config/nvim";
    };
  };

  users.defaultUserShell = pkgs.zsh;
}
