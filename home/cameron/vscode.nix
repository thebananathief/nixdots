{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      bbenoist.nix
      kamadorueda.alejandra
      gruntfuggly.todo-tree
    ];
    # keybindings = [
    #   {
    #     key = "ctrl+/";
    #     command = "";
    #     when = "";
    #   }
    # ];
  };
}
