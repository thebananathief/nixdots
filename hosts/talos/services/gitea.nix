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
    ts_code = {
      listenAddresses = [
        "100.64.252.67"
        "fd7a:115c:a1e0::9f40:fc43"
      ];
      hostName = "code.${ config.networking.fqdn }";
      extraConfig = ''
        tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key
        reverse_proxy localhost:8010
      '';
    };
    "code.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8010
      }
      handle respond "Unauthorized" 403
    '';
  };
}
