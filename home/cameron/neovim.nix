{ pkgs, config, ... }: {
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
  # xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/github/dotfiles/.config/nvim"; 

  # {
  #   source = "${config.home.homeDirectory}/github/dotfiles/.config/nvim";
  #   # source = "/home/demo/github/dotfiles/.config/nvim";
  #   target = "${config.home.homeDirectory}/.config/nvim";
  #   recursive = true;
  # };
}
