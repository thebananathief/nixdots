{ config, pkgs, ... }: { 
  #imports = [];

  home.username = "cameron";
  home.homeDirectory = "/home/cameron";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    zsh

  # Utils
    eza
    ripgrep
  ];

  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "thebananathief";
    userEmail = "cameron.salomone@gmail.com";
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
};
