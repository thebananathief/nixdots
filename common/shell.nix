{ config, lib, pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      pistol
      fzf
      zsh-fzf-tab
      ripgrep
      eza
      fd
      zoxide
      ueberzugpp
      imagemagick

      nix-zsh-completions
      zsh-completions
      any-nix-shell

    # Yazi previewers
      unar
      ffmpegthumbnailer
      jq
      poppler
    ];
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/share/zsh" ];
  };
  users.defaultUserShell = pkgs.zsh;

  programs = {
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        theme = "avit";
        plugins = [
          # "git"
          "git-auto-fetch"
          "sudo"
          # "fzf"
          # "zoxide"
        ];
      };
      autosuggestions.enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
    };

    yazi.enable = true;

    neovim.enable = true;
    neovim.defaultEditor = true;
  };
}
