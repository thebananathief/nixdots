{ config, lib, ... }: {
  options = with lib; {
    myOptions = {
      graphics.enable = mkEnableOption "Enable graphics";
      gestures.enable = mkEnableOption "Enable gestures";
      networkShares.enable = mkEnableOption "enable network shares";
      containers = {
        dataDir = mkOption {
          type = types.str;
          default = "/appdata";
          description = "Directory for nixos managed docker containers to store data.\nMake sure the `docker` group is an owner of that folder.";
        };
        gameserverDir = mkOption {
          type = types.str;
          default = "/mnt/ssd/gameservers";
          description = "Directory for high-performance gameserver data.";
        };
        downloadDir = mkOption {
          type = types.str;
          default = "/mnt/disk1/downloads";
          description = "Directory for large, long running downloads.";
        };
        storageDir = mkOption {
          type = types.str;
          default = "/mnt/storage";
          description = "Directory for multimedia, backups, general storage.";
        };
        common_env = mkOption {
          type = with types; attrsOf str;
          default = {
            PUID = "1000";
            PGID = "131"; # docker, required for the containers to access folders
            # PGID = "989"; # podman
            # PGID = "100"; # users
            # PGID = "33"; # www-data
            TZ = config.time.timeZone;
          };
          description = "Environment variables used in many containers.";
        };
      };
    };
  };
}
