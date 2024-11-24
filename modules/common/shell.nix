{ config, lib, pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      helix

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

    ## Neovim deps
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
          "fzf"
        ];
      };
      autosuggestions.enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
    };
  };
}
