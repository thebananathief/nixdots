{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  imports = [
    # ./castopod.nix
    # ./voiceserver.nix
    # ./minecraft.nix
    # ./immich.nix
    # ./ttrss.nix
    # ./whoogle.nix

    ./monitoring.nix
    ./gameserver.nix
    ./gitea.nix
    ./mediaserver.nix
    # ./webtrees.nix
    # ./syncthing.nix
    ./reverse-proxy.nix
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

  virtualisation.oci-containers.containers = {
    # whoami = {
    #   image = "traefik/whoami:latest";
    #   ports = [ "7008:80" ];
    # };
    # adminer = {
    #   image = "adminer"; # https://hub.docker.com/_/adminer
    #   ports = [ "8085:8080" ];
    #   extraOptions = [
    #   #   "--network=immich"
    #   #   "--network=ttrss"
    #     "--network=webtrees"
    #   #   "--network=castopod"
    #   ];
    # };
    dashy = {
      image = "lissy93/dashy:latest";
      volumes = [
        "${ cfg.dataDir }/dashy/config.yml:/app/public/conf.yml"
        "${ cfg.dataDir }/dashy/logos:/app/public/item-icons"
      ];
      ports = [ "8000:80" ];
      environment = {
        NODE_ENV = "production";
        UID = cfg.common_env.PUID;
        GID = cfg.common_env.PGID;
      };
    };
    # focalboard = {
    #   image = "mattermost/focalboard";
    #   ports = [ "8014:8000" ];
    # };
    # filebrowser = {
    #   image = "filebrowser/filebrowser:latest";
    #   volumes = [
    #     "${ cfg.storageDir }/filebrowser:/srv"
    #     "${ cfg.dataDir }/filebrowser/database.db:/database/filebrowser.db"
    #     "${ cfg.dataDir }/filebrowser/.filebrowser.json:/.filebrowser.json"
    #   ];
    #   ports = [ "8011:80" ];
    # };
    # hedgedoc = {
    #   image = "lscr.io/linuxserver/hedgedoc:latest";
    #   volumes = [
    #     "${ cfg.dataDir }/hedgedoc:/config"
    #   ];
    #   ports = [ "8016:3000" ];
    #   environment = {
    #     # DB_HOST = "mysql";
    #     # DB_PORT = 3306;
    #     # DB_USER = "root";
    #     # DB_PASS = "${ mysql_password }";
    #     # DB_NAME = "hedgedoc";
    #     CMD_CONFIG_FILE = ''
    #     {
    #       "dialect": "sqlite",
    #       "storage": "/config/hedgedoc.sqlite"
    #     }
    #     '';
    #     NODE_ENV = "production";
    #     CMD_URL_ADDPORT = "true";
    #     # CMD_DOMAIN = "notes.${ config.networking.fqdn }";
    #     # CMD_PROTOCOL_USESSL = "false"; #optional - use if on a reverse proxy
    #     # CMD_PORT = 3000; #optional
    #     # CMD_ALLOW_ORIGIN = "['localhost']"; #optional
    #   } // cfg.common_env;
    # };
    # grist = {
    #   image = "gristlabs/grist:latest";
    #   volumes = [
    #     "${ cfg.dataDir }/grist/persist:/persist"
    #   ];
    #   ports = [ "8484:8484" ];
    # };
  };
}
