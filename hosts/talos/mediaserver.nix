{config, ...}: let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  main_domain = secrets.main_domain.path;
in {
  services = {
    plex = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "users";
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "mediaserver";
      group = "users";
    };
    jellyseerr = {
      enable = true;
      openFirewall = true;
      port = 8005;
    };
  };
}
