{ ... }:
let
  appdata_path = "/opt/appdata/";
  storage_path = "/mnt/storage/";
  download_path = "/mnt/disk1/downloads";
  linuxserver_env = {
    PUID = "";
    PGID = "";
    TZ = "";
  };
in {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune.enable = true;
    };

    oci-containers.backend = "podman";
    oci-containers.containers = {
      plex = {
        image = "lscro.io/linuxserver/plex:latest";
        volumes = [
          "${ appdata_path }/plex:/config"
          "${ storage_path }/media:/media"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          PLEX_CLAIM = "nope";
          VERSION = "docker";
        } ++ linuxserver_env;
        extraOptions = [
          "--network=host"
        ];
      };
      traefik = {
        image = "traefik:latest";
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro"
          "${ appdata_path }/traefik:/etc/traefik"
        ];
        ports = [
          "80:80"
          "443:443"
          "8080:8080"
        ];
        environment = {
          CLOUDFLARE_EMAIL = "";
          CLOUDFLARE_API_KEY = "";
        };
        extraOptions = [
          "--network=public_access"
        ];
      };
    };
  };
}
