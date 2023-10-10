{ config, pkgs, ... }: { 
  #imports = [];

  home.username = "cameron";
  home.homeDirectory = "/home/cameron";

  home.packages = with pkgs; [
    zsh

  # Utils
    eza
    ripgrep

  # fonts
    material-symbols
    noto-fonts
    noto-fonts-emoji
    roboto
    lexend
    jost
    #(nerdfonts.override { fonts = [ "jetbrainsmono" "firacode" "firamono" "meslo" "mplus" "robotomono" ]; })
  ];

  fonts.fontconfig.enable = true;

  #qt = {
  #};
  #gtk = {
  #};
  programs = {
    home-manager.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      #generatedConfigs = {
        #lua = ''
        #''
      #};
      #extraLuaConfig = ''
      #''
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
      
    #zsh = {
      #enable = true;
      #enableAutosuggestions = true;
      #enableCompletion = true;
      #autocd = true;
      #history.ignoreAllDups = true;
      #oh-my-zsh = {
        #enable = true;
        #plugins = [
          #"git-auto-fetch"
          #"sudo"
        #];
      #};
      #syntaxHighlighting.enable = true;
      #dirHashes = {
        #nixos = "/etc/nixos";
        #gits = "$HOME/github";
      #};
    #};

    git = {
      enable = true;
      userName = "thebananathief";
      userEmail = "cameron.salomone@gmail.com";
    };
  };

  #home-manager.users.cameron = {
    #programs.starship = {
      #enable = true;
      #settings = {
        #aws.format = "";
        #bun.format = "";
        #c.format = "";
        #cmake.format = "";
        #cmd_duration.format = "";
        #cobol.format = "";
        #conda.format = "";
        #crystal.format = "";
        #daml.format = "";
        #dart.format = "";
        #deno.format = "";
        #docker_context = "";
        #dotnet.format = "";
        #elixir.format = "";
        #elm.format = "";
        #erlang.format = "";
        #fennel.format = "";
      #};
    #};
  #};

  home.stateVersion = "23.05";
}
