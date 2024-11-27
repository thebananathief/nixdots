{ config, lib, pkgs, ... }: {

  # ZSH
  environment.shells = [ pkgs.zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    # ohMyZsh = {
    #   enable = true;
    #   theme = "avit";
    #   plugins = [
    #     # "git"
    #     "git-auto-fetch"
    #     "sudo"
    #     "fzf"
    #   ];
    # };
    # autosuggestions.enable = true;
    # zsh-autoenv.enable = true;
    # syntaxHighlighting.enable = true;
  };



  # Neovim
  environment.systemPackages = with pkgs; [
    tree-sitter
    universal-ctags
    zig
    nodejs_20
    rustup
    gdu
    lazygit
    julia
    alejandra # nix format
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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
  };
}
