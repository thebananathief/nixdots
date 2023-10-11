{ config, ... }: {
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
      initExtra = builtins.readFile "${config.home.homeDirectory}/github/dotfiles/.bash_aliases";
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
}