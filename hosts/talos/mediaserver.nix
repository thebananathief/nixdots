{config, ...}: let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  main_domain = secrets.main_domain.path;
in {
  users.users.mediaserver = {
    # createHome = false;
    # uid = 1001;
    # group = "users";
    isSystemUser = true;
    description = "Mediaserver Service account";
    password = "testpassword";
  };
  services = {
    plex = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "100";
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "100";
    };
    jellyseerr = {
      enable = true;
      openFirewall = true;
      port = 8005;
    };
  };
}
