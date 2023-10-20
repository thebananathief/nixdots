{ stdenv, lib, fetchFromGitHub, makeWrapper, fzf, imagemagick, ueberzugpp, getopt }:
stdenv.mkDerivation rec {
  pname = "fontpreview-ueberzug";
  version = "f10f40c";
  # system = "x86_64-linux";

  # Broken last I checked
  # src = fetchFromGitHub {
  #   owner = "xlucn";
  #   repo = "fontpreview-ueberzug";
  #   rev = "f10f40cba0c64a506772a0ff343cd0f57237432d";
  #   sha256 = "14yvbw6k5c2g4lm06zk2m8mkh83h038zw8wq7hgld8ln5y7wn9rm";
  # };

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  # makeFlags = [
  #   "PREFIX=${placeholder "out"}"
  # ];
  # buildFlags = [ "PREFIX=$(out)" ];
  # buildInputs = [ fzf imagemagick ueberzugpp ];
  # buildPhase = ''
  # '';
  # installFlags = [ "PREFIX=$(out)" ];
  # unpackPhase = "true";


  preInstall = "mkdir -p $out/bin";
  installPhase = ''
    install -D -m 755 $src/fontpreview-ueberzug.sh $out/bin/fontpreview-ueberzug
    # cp $out/fontpreview-ueberzug $out/bin
  '';
  postInstall = ''
    wrapProgram $out/bin/fontpreview-ueberzugpp.sh \
      --prefix PATH : ${lib.makeBinPath [ imagemagick fzf ueberzugpp getopt ]}
  '';

  meta = with lib; {
    description = "Font previewer written in bash";
    homepage = https://github.com/xlucn/fontpreview-ueberzug/;
    license = licenses.mit;
    maintainers = with lib.maintainers; [];
    platforms = [ "x86_64-linux" ];
    mainProgram = "fontpreview-ueberzug";
  };
}
