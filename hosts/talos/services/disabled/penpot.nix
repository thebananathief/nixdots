{ config, pkgs, lib, ... }:
let 
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  virtualisation.oci-containers.containers = {
    penpot-frontend = {
      image = "penpotapp/frontend:latest";
      ports = [ "9001:8080" ];
      environment = {
        PENPOT_FLAGS = "disable-email-verification disable-registration enable-prepl-server disable-secure-session-cookies disable-onboarding";
        PENPOT_BACKEND_URI = "http://penpot-backend:6060";
        PENPOT_EXPORTER_URI = "http://penpot-exporter:";
      };
      volumes = [
        "${ cfg.dataDir }/penpot/backend:/opt/data/assets"
      ];
      dependsOn = [ "penpot-backend" "penpot-exporter" ];
      extraOptions = [ "--network=penpot-network" ];
    };

    penpot-backend = {
      image = "penpotapp/backend:latest";
      environment = {
        PENPOT_PUBLIC_URI = "https://penpot.talos.host";
        PENPOT_FLAGS = "disable-email-verification disable-registration enable-prepl-server disable-secure-session-cookies disable-onboarding";
        PENPOT_TELEMETRY_ENABLED = "false";
        PENPOT_DATABASE_URI = "postgresql://penpot-postgres/penpot";
        PENPOT_DATABASE_USERNAME = "penpot";
        PENPOT_DATABASE_PASSWORD = "penpot";
        PENPOT_REDIS_URI = "redis://penpot-redis/0";
        PENPOT_ASSETS_STORAGE_BACKEND = "assets-fs";
        PENPOT_STORAGE_ASSETS_FS_DIRECTORY = "/opt/data/assets";

        PENPOT_SMTP_ENABLED = "false";
      };
      volumes = [
        "${ cfg.dataDir }/penpot/backend:/opt/data/assets"
      ];
      dependsOn = [ "penpot-postgres" "penpot-redis" ];
      extraOptions = [ "--network=penpot-network" ];
    };

    penpot-exporter = {
      image = "penpotapp/exporter:latest";
      environment = {
        PENPOT_PUBLIC_URI = "https://penpot.talos.host";
        PENPOT_REDIS_URI = "redis://penpot-redis/0";
      };
      extraOptions = [ "--network=penpot-network" ];
    };

    penpot-postgres = {
      image = "postgres:15";
      environment = {
        POSTGRES_USER = "penpot";
        POSTGRES_PASSWORD = "penpot";
        POSTGRES_DB = "penpot";
        POSTGRES_INITDB_ARGS = "--data-checksums";
      };
      volumes = [
        "${ cfg.dataDir }/penpot/postgres:/var/lib/postgresql/data"
      ];
      extraOptions = [ "--network=penpot-network" "--stop-signal=SIGINT" ];
    };

    penpot-redis = {
      image = "redis:7.2";
      extraOptions = [ "--network=penpot-network" ];
    };
  };

  # Create the Docker network and volumes
  systemd.services.docker-network-penpot = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" "docker.socket" ];
    script = ''
      # Create network if it doesn't exist
      ${pkgs.docker}/bin/docker network inspect penpot-network >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create penpot-network
    '';
  };
  
  
  # Add network dependencies to the container services
  systemd.services."docker-penpot-frontend".after = [ "docker-network-penpot.service" ];
  systemd.services."docker-penpot-frontend".requires = [ "docker-network-penpot.service" ];
  systemd.services."docker-penpot-backend".after = [ "docker-network-penpot.service" ];
  systemd.services."docker-penpot-backend".requires = [ "docker-network-penpot.service" ];
  systemd.services."docker-penpot-exporter".after = [ "docker-network-penpot.service" ];
  systemd.services."docker-penpot-exporter".requires = [ "docker-network-penpot.service" ];
  systemd.services."docker-penpot-postgres".after = [ "docker-network-penpot.service" ];
  systemd.services."docker-penpot-postgres".requires = [ "docker-network-penpot.service" ];
  systemd.services."docker-penpot-redis".after = [ "docker-network-penpot.service" ];
  systemd.services."docker-penpot-redis".requires = [ "docker-network-penpot.service" ];

  # Ensure the services depend on the network by merging with existing services
  # systemd.services = lib.recursiveUpdate config.systemd.services (
  #   let
  #     mkDep = name: lib.nameValuePair
  #       "docker-penpot-${name}"
  #       { after = [ "docker-network-penpot.service" ]; requires = [ "docker-network-penpot.service" ]; };
  #   in builtins.listToAttrs (map mkDep [ "frontend" "backend" "exporter" "postgres" "redis" ])
  # );
  
  services.caddy.virtualHosts = {
    "penpot.${ config.networking.fqdn }".extraConfig = ''
      tls internal
      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:9001
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}
# https://raw.githubusercontent.com/penpot/penpot/main/docker/images/docker-compose.yaml
  
# Flags
# https://help.penpot.app/technical-guide/configuration/#advanced-configuration