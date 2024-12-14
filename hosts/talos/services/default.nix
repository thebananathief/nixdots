{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  imports = [
    # ./castopod.nix
    # ./voiceserver.nix
    # ./minecraft.nix
    # ./immich.nix
    # ./ttrss.nix
    # ./whoogle.nix

    # ./gameserver.nix
    # ./webtrees.nix
    ./syncthing.nix
    ./librespeed.nix
    ./gitea.nix
    ./mediaserver.nix
    ./etherpad.nix
    # ./dns.nix
    ./reverse-proxy.nix
  ];

  # Set the user and group ID in the environment, some containers will pull it
  environment.variables = {
    PUID = config.myOptions.containers.common_env.PUID;
    PGID = config.myOptions.containers.common_env.PGID;
  };

  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.flags = [
        "--all"
      ];
    };
    # oci-containers.backend = "podman";
    # podman = {
    #   enable = true;
    #   dockerCompat = true;
    #   dockerSocket.enable = true; # UNSAFE: This allows anyone in the "podman" group to gain root access - It also allows containers to do a bunch of stuff
    #   defaultNetwork.settings.dns_enabled = true;
    #   autoPrune.enable = true;
    #   autoPrune.flags = [
    #     "--all"
    #   ];
    # };
  };

  virtualisation.oci-containers.containers = {
    # whoami = {
    #   image = "traefik/whoami:latest";
    #   ports = [ "7008:80" ];
    # };
    # adminer = {
    #   image = "adminer"; # https://hub.docker.com/_/adminer
    #   ports = [ "8085:8080" ];
    #   extraOptions = [
    #   #   "--network=immich"
    #   #   "--network=ttrss"
    #     "--network=webtrees"
    #   #   "--network=castopod"
    #   ];
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
    # focalboard = {
    #   image = "mattermost/focalboard";
    #   ports = [ "8014:8000" ];
    # };
    # filebrowser = {
    #   image = "filebrowser/filebrowser:latest";
    #   volumes = [
    #     "${ cfg.storageDir }/filebrowser:/srv"
    #     "${ cfg.dataDir }/filebrowser/database.db:/database/filebrowser.db"
    #     "${ cfg.dataDir }/filebrowser/.filebrowser.json:/.filebrowser.json"
    #   ];
    #   ports = [ "8011:80" ];
    # };
    # hedgedoc = {
    #   image = "lscr.io/linuxserver/hedgedoc:latest";
    #   volumes = [
    #     "${ cfg.dataDir }/hedgedoc:/config"
    #   ];
    #   ports = [ "8016:3000" ];
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
    #     NODE_ENV = "production";
    #     CMD_URL_ADDPORT = "true";
    #     # CMD_DOMAIN = "notes.${ config.networking.fqdn }";
    #     # CMD_PROTOCOL_USESSL = "false"; #optional - use if on a reverse proxy
    #     # CMD_PORT = 3000; #optional
    #     # CMD_ALLOW_ORIGIN = "['localhost']"; #optional
    #   } // cfg.common_env;
    # };
    
    # dozzle = {
    #   image = "amir20/dozzle:latest"; # https://github.com/amir20/dozzle
    #   volumes = [
    #     "/var/run/docker.sock:/var/run/docker.sock"
    #     # "/run/podman/podman.sock:/var/run/docker.sock"
    #   ];
    #   ports = [ "8008:8080" ];
    # };
    # diun = {
    #   image = "ghcr.io/crazy-max/diun:latest";
    #   volumes = [
    #     "${ appdata_path }/diun:/data"
    #     # "${ appdata_path }/diun/config.yml:/diun.yml:ro"
    #     "/var/run/docker.sock:/var/run/docker.sock"
    #   ];
    #   environment = {
    #     LOG_LEVEL = "info";
    #     LOG_JSON = "false";
    #     DIUN_WATCH_WORKERS = "20";
    #     DIUN_WATCH_SCHEDULE = "0 */6 * * *";
    #     DIUN_WATCH_JITTER = "30s";
    #     DIUN_PROVIDERS_DOCKER = "true";
    #     DIUN_PROVIDERS_DOCKER_WATCHBYDEFAULT = "true";
    #   };
    #   cmd = [ "serve" ];
    # };
    # scrutiny = {
    #   image = "ghcr.io/analogj/scrutiny:master-omnibus"; # https://github.com/AnalogJ/scrutiny
    #   volumes = [
    #     "/run/udev:/run/udev:ro"
    #     "${ cfg.dataDir }/scrutiny/config:/opt/scrutiny/config"
    #     "${ cfg.dataDir }/scrutiny/influxdb:/opt/scrutiny/influxdb"
    #   ];
    #   ports = [ "8007:8080" ];
    #   extraOptions = [
    #     "--cap-add=SYS_RAWIO"
    #     "--device=/dev/sda"
    #     "--device=/dev/sdb"
    #     "--device=/dev/sdc"
    #     "--device=/dev/sdd"
    #   ];
    # };
    # smokeping = {
    #   image = "lscr.io/linuxserver/smokeping:latest";
    #   volumes = [
    #     "${ cfg.dataDir }/smokeping/config:/config"
    #     "${ cfg.dataDir }/smokeping/data:/data"
    #   ];
    #   environment = cfg.common_env;
    #   ports = [ "8015:80" ];
    # };
    # mongo = {
    #   image = "mongo:latest";
    #   # environmentFiles = [
    #   #   secrets."mongo.env".path
    #   # ];
    #   extraOptions = [
    #     "--network=host"
    #   ];
    # };
  };

  # services.smokeping = {
  #   enable = true;
  #   webService = true;
  # # By default its only listening from localhost:8081
  #   host = null;
  #   port = 8015;
  #   targetConfig = ''
  #     probe = FPing
  #     menu = Top
  #     title = Network Latency Grapher
  #     remark = TALOS SmokePing.

  #     + Global
  #     menu = Global
  #     title = Global services

  #     ++ CloudFlare
  #     host = www.cloudflare.com

  #     ++ Google
  #     host = www.google.com

  #     + Local
  #     menu = Local
  #     title = Local Network

  #     ++ Styx
  #     host = styx

  #     ++ LocalMachine
  #     menu = Local Machine
  #     title = This host
  #     host = localhost
  #   '';
  # };

  # sops.secrets = {
  #   graylog_secret = {
  #     owner = "graylog";
  #     mode = "0440";
  #   };
  #   graylog_password = {
  #     owner = "graylog";
  #   #   group = "graylog";
  #     mode = "0440";
  #   };
  #   "mongo.env" = {
  #     group = config.virtualisation.oci-containers.backend;
  #     mode = "0440";
  #   };
  # };

  # sops.secrets = {
  #   scrutiny_influx_password = {
  #     group = "influxdb2";
  #     mode = "0440";
  #   };
  #   scrutiny_influx_token = {
  #     group = "influxdb2";
  #     mode = "0440";
  #   };
  # };

  services = {
  #   scrutiny = {
  #     enable = true;
  #     openFirewall = true;
  #     collector = {
  #       enable = true;
  #     };
  #     settings = {
  #       web = {
  #         listen.host = "127.0.0.1";
  #         listen.port = 8080;

  #         influxdb = {

  #         };
  #       };
  #     };
  #   };

  #   influxdb2 = {
  #     enable = true;
  #     provision = {
  #       enable = true;
  #       initialSetup = {
  #         username = "cameron";
  #         passwordFile = secrets.scrutiny_influx_password.path;
  #         tokenFile = secrets.scrutiny_influx_token.path;
  #         bucket = "scrutiny";
  #         organization = "main";
  #         retention = 15778476; # 6 months, in seconds
  #       };
  #     };
  #   };

    # uptime-kuma = {
    #   enable = true;
    #   settings = {
    #     # By default its only listening from localhost:3001
    #     HOST = "::";
    #     PORT = "8017";
    #   };
    # };
    # elasticsearch = {
    #   enable = true;
    #   listenAddress = "127.0.0.1";
    #   port = 9200;
    #   tcp_port = 9300;
    # };
    # mongodb = {
    #   enable = true;
      # bind_ip = "127.0.0.1";
      # enableAuth = ;
      # initialRootPassword = ;
    # };
    # graylog = {
    #   enable = true;
    #   elasticsearchHosts = [ "http://127.0.0.1:9200" ];
    #   mongodbUri = "mongodb://127.0.0.1/graylog";
    #   passwordSecret = secrets.graylog_secret.path;
    #   rootUsername = username;
    #   rootPasswordSha2 = secrets.graylog_password.path;
    # };
  };

  # Make the service use the docker group ACL, for the socket access
  # systemd.services.uptime-kuma.serviceConfig.Group = "docker";

  # If needing to access externally
  # networking.firewall.allowedTCPPorts = [
  #   8017
  # ];

  # Log management services
  # services.filebeat = {
  #   enable = true;
  #   inputs = {
  #     journald.id = "everything";
  #     log = {
  #       enabled = true;
  #       paths = [
  #         "/var/log/*.log"
  #       ];
  #     };
  #   };
  #   settings.output.elasticsearch = {
  #     hosts = [ "127.0.0.1:9200" ];
  #     username = "";
  #     password = { _secret = "/run/secrets/"; };
  #   };
  # };
  #
  # services.elasticsearch = {
  #   enable = true;
  # };
}
