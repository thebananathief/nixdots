{ pkgs, config, ... }: {
  # home.packages = with pkgs; [ zsh fzf zsh-fzf-tab ];

  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        # gt = "git push";
      };
      functions = {
      };
      plugins = {
        # {
        #   name = "z";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "jethrokuan";
        #     repo = "z";
        #     rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
        #     sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
        #   };
        # };
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
