{ pkgs, configs, ... }: {
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
    source = "${configs.home.homeDirectory}/github/dotfiles/.config/nvim";
    target = "${configs.home.homeDirectory}/.config/nvim";
    recursive = true;
  };
}
