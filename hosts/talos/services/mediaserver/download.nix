{ config, pkgs, ... }:
let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  users = {
    groups.torrenter = {};
    users.torrenter = {
      uid = 986;
      group = "torrenter";
      isSystemUser = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d ${cfg.storageDir}/downloads 0775 torrenter media -"
    "d ${cfg.storageDir}/downloads/complete 0775 torrenter media -"
    "d ${cfg.storageDir}/downloads/incomplete 0775 torrenter media -"
  ];

  sops.secrets = {
    "mullvad.env" = {
      group = cfg.mediaGroup;
      mode = "0440";
    };
  };

  virtualisation.oci-containers.containers = {
    # VPN and download client
    # https://github.com/qdm12/gluetun-wiki/
    gluetun = {
      image = "docker.io/qmcgaw/gluetun:v3";
      volumes = [
        "${cfg.dataDir}/gluetun:/gluetun"
      ];
      environmentFiles = [
        secrets."mullvad.env".path # WIREGUARD_PRIVATE_KEY WIREGUARD_ADDRESSES
      ];
      environment = {
        VPN_SERVICE_PROVIDER = "mullvad";
        VPN_TYPE = "wireguard";
        SERVER_COUNTRIES = "Switzerland";
        # OWNED_ONLY = "yes"; # Use if you want only servers owned by Mullvad
      };
      extraOptions = [
        "--network=media"
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun:/dev/net/tun"
      ];
      # NOTE: Any containers using the gluetun network stack need to
      # have portforwards set here instead of that container
      ports = [
        "8001:9091" # transmission web ui
        "51413:51413" # torrent ports ?
        "51413:51413/udp"
      ];
    };
    transmission = {
      image = "lscr.io/linuxserver/transmission:latest";
      volumes = [
        "${cfg.dataDir}/transmission:/config"
        "${cfg.downloadDir}:/downloads:rw"
        # "${downloadDir}/watch:/watch" # TODO: Adjust this to a torrent blackhole
      ];
      environment = {
        PUID = "986"; # torrenter
        PGID = "987"; # media
      } // cfg.common_env;
      # This uses the gluetun network stack so that its behind VPN
      extraOptions = ["--network=container:gluetun"];
      dependsOn = ["gluetun"];
    };
  };
  
  services.caddy.virtualHosts = {
    # Transmission
    "transmission.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:8001
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}