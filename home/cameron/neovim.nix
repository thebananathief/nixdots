{ ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      lsp-zero-nvim
      toggleterm-nvim
      nvim-tree-lua
      nvim-treesitter
      comment-nvim
      tagbar
      catppuccin-nvim
      feline-nvim
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  xdg.configFile."nvim" = {
    source = "/home/cameron/github/dotfiles/.config/nvim";
    target = "/home/cameron/.config/nvim";
    recursive = true;
  };
}