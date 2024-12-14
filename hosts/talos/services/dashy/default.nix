{ config, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  # users.groups.dashy = {};
  # users.users.dashy = {
  #   uid = 980;
  #   group = "dashy";
  #   isSystemUser = true;
  # };

  virtualisation.oci-containers.containers = {
    dashy = {
      image = "lissy93/dashy:latest";
      volumes = [
        "${ cfg.dataDir }/dashy/config.yml:/app/public/conf.yml"
        "${ cfg.dataDir }/dashy/logos:/app/public/item-icons"
      ];
      ports = [ "8000:80" ];
      environment = {
        NODE_ENV = "production";
        UID = "1000";
        GID = "131";
      };
    };
  };
}