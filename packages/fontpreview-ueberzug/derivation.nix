{ stdenv, lib, fetchFromGitHub, autoPatchelfHook, makeWrapper, fzf, imagemagick, ueberzugpp }:
stdenv.mkDerivation rec {
  pname = "fontpreview-ueberzug";
  version = "f10f40c";
  system = "x86_64-linux";

  src = fetchFromGitHub {
    owner = "xlucn";
    repo = "fontpreview-ueberzug";
    rev = "f10f40cba0c64a506772a0ff343cd0f57237432d";
    sha256 = "14yvbw6k5c2g4lm06zk2m8mkh83h038zw8wq7hgld8ln5y7wn9rm";
  };

  # nativeBuildInputs = [ makeWrapper ];
  nativeBuildInputs = [
    autoPatchelfHook
  ];
  buildInputs = [
    fzf
    imagemagick
    ueberzugpp
  ];
  # buildPhase = ''
  # '';


  # preInstall = "mkdir -p $out/bin";
  # installFlags = [ "PREFIX=$(out)" ];
  # postInstall = ''
  #   wrapProgram $out/bin/fontpreview-ueberzugpp \
  #     --prefix PATH : ${lib.makeBinPath [ imagemagick fzf ueberzugpp ]}
  # '';
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp $out/fontpreview-ueberzug $out/bin
  '';

  meta = with lib; {
    description = "fontpreview-ueberzug";
    homepage = https://github.com/xlucn/fontpreview-ueberzug/;
    license = licenses.mit;
    maintainers = with lib.maintainers; [];
    platforms = [ "x86_64-linux" ];
  };
}
