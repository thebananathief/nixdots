{ config, ... }: {
  home.packages = with pkgs; [ fzf zsh-fzf-tab ];

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
          # "git"
          "git-auto-fetch"
          "sudo"
          "fzf"
        ];
      };
      syntaxHighlighting.enable = true;
      initExtra = ''
        # case insensitive tab completion
        zstyle ':completion:*' completer _complete _ignored _approximate
        zstyle ':completion:*' list-colors '\'
        zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' menu select
        zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
        zstyle ':completion:*' verbose true
        _comp_options+=(globdots)

        if [ -f ~/.bash_aliases ]; then
          . ~/.bash_aliases
        fi
      '';
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
