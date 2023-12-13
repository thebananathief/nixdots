{ config, builtins, ... }:
let 
  appdata_path = "/var/appdata";
  storage_path = "/mnt/storage";
  gameserver_path = "/ssd/gameservers";
  download_path = "/mnt/disk1/downloads";

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
  # main_domain = "talos.host";

  main_uid = "1000";
  main_gid = "100";

  linuxserver_env = {
    PUID = main_uid; # TODO: Any way to acquire my user's IDs dynamically?
    PGID = main_gid;
    # TZ = "America/New_York";
    # TZ = time.timeZone;
    TZ = config.time.timeZone;
  };

  # allContainers = 
  #   (import ./misc.nix) //
  #   (import ./database.nix); # //
    # (import ./gameserver.nix) //
    # (import ./mediaserver.nix) //
    # (import ./monitoring.nix);

in {
  imports = [
    # ./misc.nix
    # ./database.nix
    ./gameserver.nix
    # ./mediaserver.nix
    # ./monitoring.nix
  ];

  virtualisation = {
    oci-containers.backend = "podman";
    # oci-containers.containers = allContainers;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true; # UNSAFE: This allows anyone in the "podman" group to gain root access - It also allows containers to do a bunch of stuff
      defaultNetwork.settings.dns_enabled = true;
      autoPrune.enable = true;
      autoPrune.flags = [
        "--all"
      ];
    };
  };
}
