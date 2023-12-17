{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  main_domain = secrets.main_domain.path;
in {
  virtualisation.oci-containers.containers = {
    whoami = {
      image = "traefik/whoami:latest";
      ports = [ "7008:80" ];
    };
    dashy = {
      image = "lissy93/dashy:latest";
      volumes = [
        "${ cfg.dataDir }/dashy/config.yml:/app/public/conf.yml"
        "${ cfg.dataDir }/dashy/logos:/app/public/item-icons"
      ];
      ports = [ "8000:80" ];
      environment = {
        NODE_ENV = "production";
        UID = cfg.common_env.PUID;
        GID = cfg.common_env.PGID;
      };
    };
    # mumble = {
    #   image = "mumblevoip/mumble-server:latest"; # https://github.com/Theofilos-Chamalis/mumble-web
    #   volumes = [
    #     "${ cfg.dataDir }/mumble:/data"
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
    webtrees = {
      image = "dtjs48jkt/webtrees:latest"; # https://hub.docker.com/r/dtjs48jkt/webtrees/
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "${ cfg.dataDir }/webtrees/data:/var/www/html/data"
        "${ cfg.dataDir }/webtrees/modules:/var/www/html/modules_v4"
      ];
      ports = [ "8013:8079" ];
      environment = {
        DB_USER = "root";
        DB_PASSWORD = "${ secrets.mysql_password.path }";
        DB_HOST = "mysql";
        DB_PORT = "3306";
        DB_NAME = "webtrees"; # TODO: migrate "general" to "webtrees" (db name)
        WT_ADMIN = "thebananathief";
        WT_ADMINMAIL = "${ secrets.email_address.path }";
        WT_ADMINPW = "${ secrets.webtrees_password.path }";
        GROUP_ID = "${ cfg.common_env.PGID }";
        PORT = "8079";
        DISABLE_SSL = "TRUE";
        PRETTYURLS = "TRUE";
        # BASE_URL = "https://tree.${ main_domain }";
      };
      dependsOn = [ "mysql" ];
      # labels = {
      #   "traefik.enable" = "true";
      #   "traefik.http.routers.webtrees.rule" = "Host(`tree.${ main_domain }`)";
      #   "traefik.http.routers.webtrees.entrypoints" = "websecure";
      #   "traefik.http.services.webtrees.loadbalancer.server.port" = "8079";
      # };
      # extraOptions = [
      #   "--network=public_access,database_only";
      # ];
    };
    filebrowser = {
      image = "filebrowser/filebrowser:latest";
      volumes = [
        "${ cfg.storageDir }/filebrowser:/srv"
        "${ cfg.dataDir }/filebrowser/database.db:/database/filebrowser.db"
        "${ cfg.dataDir }/filebrowser/.filebrowser.json:/.filebrowser.json"
      ];
      ports = [ "8009:80" ];
      # extraOptions = [
      #   "--network=public_access";
      # ];
      # labels = {
      #   "traefik.enable" = "true";
      #   "traefik.http.routers.filebrowser.rule" = "Host(`files.${ main_domain }`)";
      #   "traefik.http.routers.filebrowser.entrypoints" = "websecure";
      # };
      # user = "${ cfg.common_env.PUID }:${ cfg.common_env.PGID}";
      # user = "cameron:docker";
    };
    # static = {
    #   image = "nginx:alpine";
    #   volumes = [
    #     "${ cfg.storageDir }/filebrowser:/usr/share/nginx/html:ro"
    #   ];
    #   ports = [ "8010:80" ];
    #   # extraOptions = [
    #   #   "--network=public_access";
    #   # ];
    #   # labels = {
    #   #   "traefik.enable" = "true";
    #   #   "traefik.http.routers.static.rule" = "Host(`static.${ main_domain }`)";
    #   #   "traefik.http.routers.static.entrypoints" = "websecure";
    #   # };
    # };
    # hedgedoc = {
    #   image = "lscr.io/linuxserver/hedgedoc:latest";
    #   volumes = [
    #     "${ cfg.dataDir }/hedgedoc:/config"
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
    #     "${ cfg.dataDir }/ttrss/feed-icons:/var/www/feed-icons/"
    #   ];
    #   ports = [ "8011:80" ];
    #   environment = {
    #     # SELF_URL_PATH = "https://rss.${ main_domain }/";
    #     # PUID = "${ cfg.common_env.PUID }";
    #     # PGID = "${ main_gid }";
    #     DB_HOST = "postgres";
    #     DB_PORT = "5432";
    #     DB_USER = "postgres";
    #     DB_PASS = "${ secrets.postgres_password.path }";
    #   } // cfg.common_env;
    #   extraOptions = [
    #     # "--network=public_access,database_only"
    #     "--tty"
    #     "--interactive"
    #   ];
    #   dependsOn = [ "postgres" ];
    #   # labels = {
    #   #   "traefik.enable" = "true";
    #   #   "traefik.http.routers.rss.rule" = "Host(`rss.${ main_domain }`)";
    #   #   "traefik.http.routers.rss.entrypoints" = "websecure";
    #   # };
    # };
    # traefik = {
    #   image = "traefik:latest";
    #   volumes = [
    #     "/var/run/docker.sock:/var/run/docker.sock:ro" # TODO: migrate to podman socket
    #     "${ cfg.dataDir }/traefik:/etc/traefik" # TODO: Need to get our traefik.yml file out here BEFORE the container starts
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
    #     "${ cfg.dataDir }/adguard/conf:/opt/adguardhome/conf"
    #     "${ cfg.dataDir }/adguard/work:/opt/adguardhome/work"
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