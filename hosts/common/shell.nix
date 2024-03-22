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
      alejandra # nix format

    # Yazi previewers
      # unar
      # ffmpegthumbnailer
      # jq
      # poppler

    ## Neovim
      tree-sitter
      universal-ctags
      zig
      nodejs_20
      rustup
      gdu
      lazygit
      julia
      (python311.withPackages (ps:
        with ps; [
          # Neovim
          pip
          yamllint
          pynvim
          black # py format
      ]))
      luajitPackages.luarocks
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
          "git"
          "git-auto-fetch"
          "sudo"
          "fzf"
          "zoxide"
        ];
      };
      autosuggestions.enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
    };

    # yazi.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
    };
  };
}
