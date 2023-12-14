{ config, builtins, ... }:
let 
  inherit (config.sops) secrets;
  # TODO: See if these are reading in the secrets just to store them in the /nix/store
  
  # Get secret file's path, read the contents and store them
  # mysql_password = "asd123asd123";
  # mysql_password = "$__file{${secrets.mysql_password.path}}";
  # mumble_superpassword = "$__file{${secrets.mumble_superpassword.path}}";
  # email_address = "$__file{${secrets.email_address.path}}";
  # main_domain = "$__file{${secrets.main_domain.path}}";
  # cloudflare_email = "$__file{${secrets.cloudflare_email.path}}";
  # cloudflare_apikey = "$__file{${secrets.cloudflare_apikey.path}}";
  # webtrees_password = "$__file{${secrets.webtrees_password.path}}";
  # postgres_password = "123asd123asd";
  # postgres_password = "$__file{${secrets.postgres_password.path}}";
  # mullvad_privKey = "$__file{${secrets.mullvad_privKey.path}}";

  # main_domain = builtins.readFile secrets.main_domain.path;
  # main_domain = "$__file{${secrets.main_domain.path}}";
in {
  imports = [
    ./misc.nix
    ./database.nix
    ./gameserver.nix
    # ./mediaserver.nix
    ./monitoring.nix
  ];

  virtualisation = {
    # oci-containers.backend = "podman";
    oci-containers.backend = "docker";
    # oci-containers.containers = allContainers;
    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.flags = [
        "--all"
      ];
    };
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
