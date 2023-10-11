{ ... }: {
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;
      history.ignoreAllDups = true;
      oh-my-zsh = {
        enable = true;
        theme = "avit";
        plugins = [
          "git-auto-fetch"
          "sudo"
        ];
      };
      syntaxHighlighting.enable = true;
      profileExtra = builtins.readFile "/home/cameron/github/dotfiles/.bash_aliases";
    };

    fzf = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    autojump = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
  # home.file.".bash_aliases".text = builtins.readFile "/home/cameron/github/dotfiles/.bash_aliases";
}