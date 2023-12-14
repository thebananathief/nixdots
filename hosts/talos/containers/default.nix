{ config, builtins, ... }:
{
  imports = [
    ./misc.nix
    ./database.nix
    ./gameserver.nix
    ./mediaserver.nix
    ./monitoring.nix
  ];

  environment.variables = {
    PUID = "1000";
    PGID = "131";
  }

  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.flags = [
        "--all"
      ];
    };
    # TODO: Transition to podman - was breaking last i tried
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
