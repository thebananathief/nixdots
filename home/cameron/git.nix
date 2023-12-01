{ ... }: {
  programs.git = {
    enable = true;
    userName = "thebananathief";
    userEmail = "cameron.salomone@gmail.com";
    ignores = [ "*~" "*.swp" "*result*" ".direnv" "node_modules" ];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;

      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
        "ssh://git@gitlab.com/" = {
          insteadOf = "https://gitlab.com/";
        };
        "ssh://git@bitbucket.com/" = {
          insteadOf = "https://bitbucket.com/";
        };
      };

      # diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
    };
    aliases = {
      a = "add --all";
      b = "branch";
      c = "commit";
      ca = "commit --amend";
      cm = "commit -m";
      co = "checkout";
      d = "diff";
      ds = "diff --staged";
      p = "push";
      pf = "push --force-with-lease";
      pl = "pull";
      l = "log --graph";
      r = "rebase";
      s = "status --short";
      ss = "status";
      forgor = "commit --amend --no-edit";
      graph = "log --all --decorate --graph --oneline";
      oops = "checkout --";
    };
  };
}
