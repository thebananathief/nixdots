{ config, lib, pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
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
      alejandra

    # Yazi previewers
      unar
      ffmpegthumbnailer
      jq
      poppler

    ## Neovim
      tree-sitter
      universal-ctags
      zig
    ];
    shells = [ pkgs.zsh ];
    # shells = [ pkgs.fish ];
    pathsToLink = [ "/share/zsh" ];
  };
  users.defaultUserShell = pkgs.zsh;
  # users.defaultUserShell = pkgs.fish;

  programs = {
    # fish.enable = true;

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
