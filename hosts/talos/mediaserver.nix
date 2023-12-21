{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  users.groups.mediaserver = {};
  users.users.mediaserver = {
    # uid = 1001;
    group = "mediaserver";
    isSystemUser = true;
    description = "Mediaserver Service account";
    # hashedPasswordFile = secrets.main_user_password.path;
    password = "testpassword"; # TODO: obfuscate
  };
  services = {
    plex = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "mediaserver";
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "mediaserver";
    };
    jellyseerr = {
      enable = true;
      openFirewall = true;
      port = 8005;
    };
    sonarr = {
      enable = true;
      openFirewall = false;
      user = "mediaserver";
      group = "mediaserver";
      # dataDir = "/var/lib/sonarr/.config/NzbDrone";
    };
    radarr = {
      enable = true;
      openFirewall = false;
      user = "mediaserver";
      group = "mediaserver";
      # dataDir = "/var/lib/radarr/.config/Radarr";
    };
  };
}
