{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [ "*~" "*.swp" "*result*" ".direnv" "node_modules" ];
    settings = {
      user.name = "thebananathief";
      user.email = "cameron.salomone@gmail.com";

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
      
      aliases = {
        a = "add --all";
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

        g = "lazygit";
        t = "push";
        b = "pull";
      };
    };
  };
}
