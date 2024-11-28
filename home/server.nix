{ pkgs, lib, ... }: rec {
  home = {
    username = "cameron";
    # home.homeDirectory = "/home/cameron";

    # sessionVariables = {
    #   PAGER = "bat -pl man --pager='less -KRF'";
    # };

    shellAliases = {
      dtail = "docker logs -tf --tail='50'";
      dstop = "docker stop `docker ps -aq`";
      drm = "docker rm `docker ps -aq`";
      # dps = "docker ps --format 'table {{ '{{' }}.Names{{ '}}' }}\\t{{ '{{' }}.Ports{{ '}}' }}\\t{{ '{{' }}.Status{{ '}}' }}'";
      appd = "cd /appdata";
      stor = "cd /mnt/storage";
    };

    packages = with pkgs; [
      lynis
      lazydocker
    ];
    
    # Think these might already be handled by config.programs.zsh/neovim (common)
    # sessionVariables = {
    #   EDITOR = "nvim";
    #   SHELL = "zsh";
    # };
  };

  programs = {
    home-manager.enable = true;

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      icons = null;
      extraOptions = [
        "--all"
        "--color=always"
        "--group"
      ];
    };

    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        manager.show_hidden = true;
      };
    };
  };

  home.stateVersion = "23.05";
}
