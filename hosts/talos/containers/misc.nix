{ config, ... }:
let
  containerCfg = config.myOptions.containers;
in {
  virtualisation.oci-containers.containers = {
    # whoami = {
    #   image = "traefik/whoami:latest";
    #   ports = [ "80:80" ];
    # };
    dashy = {
      image = "lissy93/dashy:latest";
      volumes = [
        "${ containerCfg.dataDir }/dashy/config.yml:/app/public/conf.yml"
        "${ containerCfg.dataDir }/dashy/logos:/app/public/item-icons"
      ];
      ports = [ "8081:80" ];
      environment = {
        NODE_ENV = "production";
        UID = containerCfg.common_env.PUID;
        # docker group?
        GID = "131";
      };
      # user = "cameron:users";
      # BUG: Errors with this for some reason
      extraOptions = [
        "--health-cmd='[CMD, node, /app/services/healthcheck]'"
        "--health-interval=1m30s"
        "--health-retries=3"
        "--health-start-period=40s"
        "--health-timeout=10s"
      ];
    };
    # mumble = {
    #   image = "mumblevoip/mumble-server:latest"; # https://github.com/Theofilos-Chamalis/mumble-web
    #   volumes = [
    #     "${ containerCfg.dataDir }/mumble:/data"
    #   ];
    #   ports = [ "64738:64738" ];
    #   environment = {
    #     MUMBLE_CONFIG_WELCOMETEXT = "Welcome to the Shire! Have a grand time and don't disturb the hobbits!";
    #     MUMBLE_SUPERUSER_PASSWORD = "${ mumble_superpassword }";
    #   };
    #   # labels = {
    #   #   # https://github.com/PHLAK/docker-mumble/issues/15
    #   #   "traefik.enable" = true;
    #   # };
    # };
    # webtrees = {
    #   image = "dtjs48jkt/webtrees:latest"; # https://hub.docker.com/r/dtjs48jkt/webtrees/
    #   volumes = [
    #     "/etc/localtime:/etc/localtime:ro"
    #     "${ containerCfg.dataDir }/webtrees/data:/var/www/html/data"
    #     "${ containerCfg.dataDir }/webtrees/modules:/var/www/html/modules_v4"
    #   ];
    #   environment = {
    #     DB_USER = "root";
    #     DB_PASSWORD = "${ mysql_password }";
    #     DB_HOST = "mysql";
    #     DB_PORT = "3306";
    #     DB_NAME = "general"; # TODO: migrate "general" to "webtrees" (db name)
    #     WT_ADMIN = "thebananathief";
    #     WT_ADMINMAIL = "${ email_address }";
    #     WT_ADMINPW = "${ webtrees_password }";
    #     GROUP_ID = "${ main_gid }";
    #     PORT = "8079";
    #     DISABLE_SSL = "TRUE";
    #     PRETTYURLS = "TRUE";
    #     BASE_URL = "https://tree.${ main_domain }";
    #   };
    #   dependsOn = [ "mysql" ];
    #   labels = {
    #     "traefik.enable" = "true";
    #     "traefik.http.routers.webtrees.rule" = "Host(`tree.${ main_domain }`)";
    #     "traefik.http.routers.webtrees.entrypoints" = "websecure";
    #     "traefik.http.services.webtrees.loadbalancer.server.port" = "8079";
    #   };
    #   # extraOptions = [
    #   #   "--network=public_access,database_only";
    #   # ];
    # };
    # filebrowser = {
    #   image = "filebrowser/filebrowser:latest";
    #   volumes = [
    #     "${ storage_path }/filebrowser:/srv"
    #     "${ containerCfg.dataDir }/filebrowser/database.db:/database/filebrowser.db"
    #     "${ containerCfg.dataDir }/filebrowser/.filebrowser.json:/.filebrowser.json"
    #   ];
    #   # extraOptions = [
    #   #   "--network=public_access";
    #   # ];
    #   labels = {
    #     "traefik.enable" = "true";
    #     "traefik.http.routers.filebrowser.rule" = "Host(`files.${ main_domain }`)";
    #     "traefik.http.routers.filebrowser.entrypoints" = "websecure";
    #   };
    #   user = "${ main_uid }";
    # };
    # static = {
    #   image = "nginx:alpine";
    #   volumes = [
    #     "${ storage_path }/filebrowser:/usr/share/nginx/html:ro"
    #   ];
    #   # extraOptions = [
    #   #   "--network=public_access";
    #   # ];
    #   labels = {
    #     "traefik.enable" = "true";
    #     "traefik.http.routers.static.rule" = "Host(`static.${ main_domain }`)";
    #     "traefik.http.routers.static.entrypoints" = "websecure";
    #   };
    # };
    # hedgedoc = {
    #   image = "lscr.io/linuxserver/hedgedoc:latest";
    #   volumes = [
    #     "${ containerCfg.dataDir }/hedgedoc:/config"
    #   ];
    #   environment = {
    #     # DB_HOST = "mysql";
    #     # DB_PORT = 3306;
    #     # DB_USER = "root";
    #     # DB_PASS = "${ mysql_password }";
    #     # DB_NAME = "hedgedoc";
    #     CMD_CONFIG_FILE = ''
    #     {
    #       "dialect": "sqlite",
    #       "storage": "/config/hedgedoc.sqlite"
    #     }
    #     '';
    #     CMD_DOMAIN = "notes.${ main_domain }";
    #     CMD_PROTOCOL_USESSL = "true"; #optional - use if on a reverse proxy
    #     # CMD_URL_ADDPORT = false; #optional
    #     # CMD_PORT = 3000; #optional
    #     # CMD_ALLOW_ORIGIN = "['localhost']"; #optional
    #   } ++ linuxserver_env;
    #   # extraOptions = [
    #   #   "--network=public_access,database_only";
    #   # ];
    #   labels = {
    #     "traefik.enable" = "true";
    #     "traefik.http.routers.hedgedoc.rule" = "Host(`notes.${ main_domain }`)";
    #     "traefik.http.routers.hedgedoc.entrypoints" = "websecure";
    #     "traefik.http.services.hedgedoc.loadbalancer.server.port" = "3000";
    #   };
    # };
    # rss = {
    #   image = "wangqiru/ttrss:latest";
    #   volumes = [
    #     "${ containerCfg.dataDir }/ttrss/feed-icons:/var/www/feed-icons/"
    #   ];
    #   environment = {
    #     SELF_URL_PATH = "https://rss.${ main_domain }/";
    #     PUID = "${ main_uid }";
    #     PGID = "${ main_gid }";
    #     DB_HOST = "postgres";
    #     DB_PORT = "5432";
    #     DB_USER = "postgres";
    #     DB_PASS = "${ postgres_password }";
    #   };
    #   extraOptions = [
    #     # "--network=public_access,database_only"
    #     "--tty"
    #     "--interactive"
    #   ];
    #   dependsOn = [ "postgres" ];
    #   labels = {
    #     "traefik.enable" = "true";
    #     "traefik.http.routers.rss.rule" = "Host(`rss.${ main_domain }`)";
    #     "traefik.http.routers.rss.entrypoints" = "websecure";
    #   };
    # };
    # traefik = {
    #   image = "traefik:latest";
    #   volumes = [
    #     "/var/run/docker.sock:/var/run/docker.sock:ro" # TODO: migrate to podman socket
    #     "${ containerCfg.dataDir }/traefik:/etc/traefik" # TODO: Need to get our traefik.yml file out here BEFORE the container starts
    #   ];
    #   ports = [
    #     "80:80"
    #     "443:443"
    #     "8080:8080"
    #   ];
    #   environment = {
    #     CLOUDFLARE_EMAIL = "${ cloudflare_email }";
    #     CLOUDFLARE_API_KEY = "${ cloudflare_apikey }";
    #   };
    #   # extraOptions = [ "--network=public_access" ];

    #   # TODO: Prefer config only with labels - Take from appdata backup's traefik.yml

    #   # -- OLD DCP FILE --
    #   # command:
    #   # - "--entrypoints.mumble_tcp.address=:64738"
    #   # - "--entrypoints.mumble_udp.address=:64738/udp"
    #   # - "--certificatesresolvers.cloudflare.acme.caserver=https://acme-v02.api.letsencrypt.org/directory"
    #   # extra_hosts: # https://doc.traefik.io/traefik/providers/docker/#host-networking
    #   #   - host.docker.internal:172.18.0.1
    # };
    # adguard = {
    #   image = "adguard/adguardhome:latest"; # https://hub.docker.com/r/adguard/adguardhome
    #   volumes = [
    #     "${ containerCfg.dataDir }/adguard/conf:/opt/adguardhome/conf"
    #     "${ containerCfg.dataDir }/adguard/work:/opt/adguardhome/work"
    #   ];
    #   ports = [
    #     "53:53"
    #     "853:853/tcp"
    #     "81:80/tcp"
    #     "444:443/tcp"
    #     "3000:3000/tcp"
    #   ];
    #   extraOptions = [
    #     "--network=public_access"
    #     "--cap-add=NET_ADMIN"
    #   ];
    # };
  };
}