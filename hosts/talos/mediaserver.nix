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
      # TODO: Submit PR so that this module has the other's features
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "mediaserver";
      # TODO: Submit PR so that this module has the other's features
    };
    jellyseerr = {
      enable = true;
      openFirewall = true;
      port = 8005;
      # TODO: Submit PR so that this module has the other's features
    };
    sonarr = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "mediaserver";
      # dataDir = "/var/lib/sonarr/.config/NzbDrone";
      # TODO: Submit PR so that this module has the other's features
    };
    radarr = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "mediaserver";
      # dataDir = "/var/lib/radarr/.config/Radarr";
      # TODO: Submit PR so that this module has the other's features
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
      # TODO: Submit PR so that this module has the other's features
    };
  };
}
