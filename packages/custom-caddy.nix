# https://mdleom.com/blog/2021/12/27/caddy-plugins-nixos/#xcaddy

{ pkgs, config, plugins, stdenv, lib, ... }:

stdenv.mkDerivation rec {
  pname = "caddy";
  # https://github.com/NixOS/nixpkgs/issues/113520
  version = "2.8.4";
  dontUnpack = true;

  nativeBuildInputs = [ pkgs.git pkgs.go pkgs.xcaddy ];

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
  '';

  buildPhase =
    let
      pluginArgs =
        lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
    in
    ''
      runHook preBuild
      ${pkgs.xcaddy}/bin/xcaddy build latest ${pluginArgs}
      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv caddy $out/bin
    runHook postInstall
  '';
  
  meta = with lib; {
    # description = "Simple wrapper around the VTE terminal emulator widget for GTK";
    # homepage = "https://github.com/esmil/stupidterm";
    # license = licenses.lgpl3Plus;
    # maintainers = [ maintainers.etu ];
    # platforms = platforms.linux;
    mainProgram = "caddy";
  };
}