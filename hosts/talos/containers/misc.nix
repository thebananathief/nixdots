{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  main_domain = "$__file{${secrets.main_domain.path}}";
in {
  virtualisation.oci-containers.containers = {
    # whoami = {
    #   image = "traefik/whoami:latest";
    #   ports = [ "7008:80" ];
    # };
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
    # };
    webtrees = {
      image = "dtjs48jkt/webtrees:latest"; # https://hub.docker.com/r/dtjs48jkt/webtrees/
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "${ cfg.dataDir }/webtrees/data:/var/www/html/data"
        "${ cfg.dataDir }/webtrees/modules:/var/www/html/modules_v4"
      ];
      ports = [ "8013:8013" ];
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
        PORT = "8013";
        DISABLE_SSL = "TRUE";
        PRETTYURLS = "TRUE";
        BASE_URL = "https://tree.${ main_domain }";
      };
      dependsOn = [ "mysql" ];
      extraOptions = [
        "--network=database_mysql"
      ];
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
    # };
  };
}