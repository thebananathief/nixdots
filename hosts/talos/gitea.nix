{ ... }:
{
  # services.gitea = {
  #   enable = true;
  #   user = "gitea";
  #   group = "gitea";
  #   lfs.enable = true;
  #   settings = {
  #     server = {
  #       DOMAIN = "localhost";
  #       PROTOCOL = "http";
  #       HTTP_ADDR = "0.0.0.0"; # listen on details
  #       HTTP_PORT = 8010;
  #     };
  #   };
  # };
  virtualization.oci-containers.containers = {
    gitea = {
      image = "gitea/gitea:latest-rootless";
      volumes = [
        "${ cfg.dataDir }/gitea/data:/var/lib/gitea"
        "${ cfg.dataDir }/gitea/config:/etc/gitea"
        "/etc/timezone:/etc/timezone:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      ports = [
        "8010:3000"
        "2222:2222"
      ];
    };
  };
}
