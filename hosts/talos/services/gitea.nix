{ config, ... }:
let
  cfg = config.myOptions.containers;
in {
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
  
  # should work with podman too
  virtualisation.oci-containers.containers = {
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

  services.caddy.virtualHosts = {
    "code.${ config.networking.fqdn }".extraConfig = ''
      @authorized {
        remote_ip 192.168.0.0/24
      }

      handle @authorized {
        reverse_proxy localhost:8010
        tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
      }

      handle {
          respond "Unauthorized" 403
      }
    '';
  };
}
