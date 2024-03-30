{ lib, stdenv, fetchurl, nixosTests, jre_headless, version, url, sha256 }: 
stdenv.mkDerivation {
  # name = "minecraft-forge";
  pname = "minecraft-neoforge";
  inherit version;

  src = fetchurl { inherit url sha256; };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/minecraft
    cp -v $src $out/lib/minecraft/neoforge-installer.jar

    ${jre_headless}/bin/java -jar $out/lib/minecraft/neoforge-installer.jar --installServer
    
    cat > $out/bin/minecraft-server << EOF
    #!/bin/sh
    exec ${jre_headless}/bin/java \$@ @libraries/net/neoforged/forge/${version}/unix_args.txt
    EOF
    
    chmod +w server.properties # for overwriting after a change
    chmod +x $out/bin/minecraft-server
  '';
  
  meta = with lib; {
    description = "Neoforge Minecraft Server Install Jar";
    homepage = "https://neoforged.net/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    # maintainers = with maintainers; [  ];
  };
};

