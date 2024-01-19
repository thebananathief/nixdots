{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  virtualisation.oci-containers.containers = {
    dozzle = {
      image = "amir20/dozzle:latest"; # https://github.com/amir20/dozzle
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        # "/run/podman/podman.sock:/var/run/docker.sock"
      ];
      ports = [ "8008:8080" ];
    };
    # grafana = {
    #   image = "grafana/grafana-oss:latest"; # https://hub.docker.com/r/grafana/grafana/
    #   # TODO: Grafana needs to be configured for mysql (/etc/grafana/grafana.ini) - Do this with nixos
    #   # Manually chown its volume to 472:0 (grafana container uses user 472 ?)
    #   # user = "cameron"; # does this solve it?
    #   volumes = [
    #     "${ appdata_path }/grafana/data:/var/lib/grafana:rw"
    #     "${ appdata_path }/grafana/grafana.ini:/etc/grafana/grafana.ini"
    #   ];
    #   ports = [ "3030:3000" ];
    #   dependsOn = [ "mysql" ];
    #   # extraOptions = [ "--network=database_only" ];
    #   # environment = {
    #   #   GF_INSTALL_PLUGINS = "put plugin names or url to zips here"
    #   # };
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
    scrutiny = {
      image = "ghcr.io/analogj/scrutiny:master-omnibus"; # https://github.com/AnalogJ/scrutiny
      volumes = [
        "/run/udev:/run/udev:ro"
        "${ cfg.dataDir }/scrutiny/config:/opt/scrutiny/config"
        "${ cfg.dataDir }/scrutiny/influxdb:/opt/scrutiny/influxdb"
      ];
      ports = [ "8007:8080" ];
      extraOptions = [
        "--cap-add=SYS_RAWIO"
        "--device=/dev/sda"
        "--device=/dev/sdb"
        "--device=/dev/sdc"
        "--device=/dev/sdd"
      ];
    };
    librespeed = {
      image = "lscr.io/linuxserver/librespeed:latest"; # https://github.com/AnalogJ/scrutiny
      volumes = [
        "${ cfg.dataDir }/librespeed:/config"
      ];
      environment = {
        PASSWORD = "PASSWORD";
      } // cfg.common_env;
      ports = [ "8016:80" ];
    };
    smokeping = {
      image = "lscr.io/linuxserver/smokeping:latest";
      volumes = [
        "${ cfg.dataDir }/smokeping/config:/config"
        "${ cfg.dataDir }/smokeping/data:/data"
      ];
      environment = cfg.common_env;
      ports = [ "8015:80" ];
    };
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
  
  # TODO: Put in a PR to improve this service config
  services.uptime-kuma = {
    enable = true;
    settings = {
      # By default its only listening from localhost:3001
      HOST = "::";
      PORT = "8017";
    };
  };

  # Make the service use the docker group ACL, for the socket access
  # systemd.services.uptime-kuma.serviceConfig.Group = "docker";
    
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
