{ config, builtins, ... }:
{
  imports = [
    ./misc.nix
    ./database.nix
    ./gameserver.nix
    ./mediaserver.nix
    ./monitoring.nix
  ];

  # Set the user and group ID in the environment, some containers will pull it
  environment.variables = {
    PUID = config.myOptions.containers.common_env.PUID;
    PGID = config.myOptions.containers.common_env.PGID;
  };

  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.flags = [
        "--all"
      ];
    };
    # oci-containers.backend = "podman";
    # podman = {
    #   enable = true;
    #   dockerCompat = true;
    #   dockerSocket.enable = true; # UNSAFE: This allows anyone in the "podman" group to gain root access - It also allows containers to do a bunch of stuff
    #   defaultNetwork.settings.dns_enabled = true;
    #   autoPrune.enable = true;
    #   autoPrune.flags = [
    #     "--all"
    #   ];
    # };
  };
}
