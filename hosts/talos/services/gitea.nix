{ config, ... }:
let
  cfg = config.mediaServer;
in {
  # users.users.gitea = { 
  #   isSystemUser = true; 
  #   group = "gitea"; 
  # };
  # users.groups.gitea = {};

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

  virtualisation.oci-containers.containers = {
    gitea = {
      image = "gitea/gitea:latest-rootless";
      volumes = [
        "${ cfg.dataDir }/gitea/data:/var/lib/gitea"
        "${ cfg.dataDir }/gitea/config:/etc/gitea"
        "/etc/timezone:/etc/timezone:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        PUID = "1000"; # cameron
        PGID = "131"; # docker
      };
      ports = [
        "8010:3000"
        "2222:2222"
      ];
    };
  };

  services.caddy.virtualHosts = {
    # Extra host entry so that we can bind it to tailscale's interface
    # ts_code = {
    #   listenAddresses = config.tailscaleInterfaces;
    #   hostName = "code.${ config.networking.fqdn }";
    #   extraConfig = ''
    #     tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
    #     reverse_proxy localhost:8010
    #   '';
    # };
    "code.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8010
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}
