{ pkgs, ... }:
let
    # Fixed crashes from EGL something rather
    # obsid = pkgs.symlinkJoin {
    #   name = "obsidian";
    #   paths = [ pkgs.obsidian ];
    #   buildInputs = [ pkgs.makeWrapper ];
    #   postBuild = ''
    #     wrapProgram $out/bin/obsidian \
    #       --add-flags "--disable-gpu"
    #   '';
    # };
in {
  environment.systemPackages = with pkgs; [
    efibootmgr
    jsonfmt
    go

    # (python311.withPackages (ps:
    #   with ps; [
    #     ansible
    # ]))

    # TODO: setup some flake shit to automatically log in and create the sync
    megacmd
    wireguard-tools
  ];
}
