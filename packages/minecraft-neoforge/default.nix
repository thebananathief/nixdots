{ callPackage, lib, javaPackages }:
let
  versions = lib.importJson ./versions.json;
  
  latestVersion = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
  escapeVersion = builtins.replaceStrings [ "." ] [ "-" ];

  getJavaVersion = v: (builtins.getAttr "openjdk${toString v}" javaPackages.compiler).headless;

  packages = lib.mapAttrs'
    (version: value: {
      name = "neoforge-${escapeVersion version}";
      value = callPackage ./derivation.nix {
        inherit (value) version url sha256;
        jre_headless = getJavaVersion (if value.javaVersion == null then 8 else value.javaVersion); # versions <= 1.6 will default to 8
      };
    })
    versions;
in
lib.recurseIntoAttrs (
  packages // {
    neoforge = builtins.getAttr "neoforge-${escapeVersion latestVersion}" packages;
  }
)


  # neoforgeServer = pkgs.callPackage ../../packages/minecraft-neoforge/derivation.nix {
  #   sha256 = "09pmvwvvic6wxrwjlcvwzgk9yf08wzvn9k23i3c7k44rrfyiaaxb";
  #   url = "https://maven.neoforged.net/releases/net/neoforged/forge/1.20.1-47.1.84/forge-1.20.1-47.1.84-installer.jar";
  #   version = "1.20.1-47.1.84";
  #   jre_headless = (builtins.getAttr "openjdk${toString 17}" pkgs.javaPackages.compiler).headless;
  # };
  # environment.systemPackages = neoforgeServer;