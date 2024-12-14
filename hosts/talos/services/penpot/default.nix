{ ... }:
let 
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  virtualisation.oci-containers.containers = {
    penpot = {
      # image = "lissy93/dashy:latest";
      # volumes = [
      #   "${ cfg.dataDir }/dashy/config.yml:/app/public/conf.yml"
      #   "${ cfg.dataDir }/dashy/logos:/app/public/item-icons"
      # ];
      # ports = [ "8000:80" ];
      # environment = {
      #   NODE_ENV = "production";
      #   UID = "1000";
      #   GID = "131";
      # };
    };
  };
}
# https://raw.githubusercontent.com/penpot/penpot/main/docker/images/docker-compose.yaml