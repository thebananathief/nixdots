{ pkgs, config, ... }: {
  # home.packages = with pkgs; [ zsh fzf zsh-fzf-tab ];

  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
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
          "zoxide"
        ];
      };
      syntaxHighlighting.enable = true;
      # initExtraBeforeCompInit = ''
        # export CLICOLOR=1
        # export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
        # export XDG_DATA_DIRS=/home/cameron/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS
      # '';
      initExtra = ''
        # case insensitive tab completion
        zstyle ':completion:*' completer _complete _ignored _approximate
        # zstyle ':completion:*' list-colors '\'
        # zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
        # zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' menu select
        # zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
        # zstyle ':completion:*' verbose true
        _comp_options+=(globdots)

        # source ~/.config/zsh/fzf/fzf-tab.plugin.zsh
        source ~/.bash_aliases
      '';
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true; # i think this is the same as declaring it in ohmyzsh plugins
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true; # i think this is the same as declaring it in ohmyzsh plugins
      defaultOptions = [
        "--preview 'pistol {}'"
      ];
    };
  };
}
