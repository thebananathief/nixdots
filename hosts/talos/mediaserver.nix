{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  main_domain = "$__file{${secrets.main_domain.path}}";
in {
  users.groups.mediaserver = {};
  users.users.mediaserver = {
    # createHome = false;
    # uid = 1001;
    group = "mediaserver";
    isSystemUser = true;
    description = "Mediaserver Service account";
    password = "testpassword";
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
  };
}
