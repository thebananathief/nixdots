{config, ...}: let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  imports = [
    ./caddy.nix
    ./starbase.nix

    # ./gameserver/minecraft-vanilla.nix
    # ./gameserver/kf2.nix
    ./options.nix
    ./syncthing.nix
    ./librespeed.nix
    ./gitea.nix
    ./qubic.nix
    ./mediaserver
    # ./homeassistant.nix
  ];

  # Set the user and group ID in the environment, some containers will pull it
  # environment.variables = {
  #   PUID = "1000"; # cameron
  #   PGID = "131"; # docker
  # };

  virtualisation = {
    # oci-containers.backend = "docker";
    # docker = {
    #   enable = true;
    #   autoPrune.enable = true;
    #   autoPrune.flags = [
    #     "--all"
    #   ];
    # };
    # oci-containers.backend = "podman";
    podman = {
      enable = true;
      # dockerCompat = true; # Creates an alias for "docker" to "podman"
      # dockerSocket.enable = true; # UNSAFE: This allows anyone in the "podman" group to gain root access - It also allows containers to do a bunch of stuff
      defaultNetwork.settings.dns_enabled = true;
      autoPrune.enable = true;
      autoPrune.flags = [
        "--all"
      ];
    };
  };
}
