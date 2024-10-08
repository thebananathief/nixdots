{pkgs, config, ...}: {
  # virtualisation = {
    # oci-containers.backend = "docker";
    # docker = {
    #   enable = true;
    #   autoPrune.enable = true;
    #   autoPrune.flags = [
    #     "--all"
    #   ];
    # };
  #   oci-containers.backend = "podman";
  #   podman = {
  #     enable = true;
  #     dockerCompat = true;
  #   #   dockerSocket.enable = true; # UNSAFE: This allows anyone in the "podman" group to gain root access - It also allows containers to do a bunch of stuff
  #     defaultNetwork.settings.dns_enabled = true;
  #     autoPrune.enable = true;
  #     autoPrune.flags = [
  #       "--all"
  #     ];
  #   };
  # };

  # environment.systemPackages = with pkgs; [
    # podman-compose
    # dive
    # podman-tui
    # mailutils
  # ];

  # systemd.services.podman-create-pod-testdb = {
  #   serviceConfig.Type = "oneshot";
  #   wantedBy = [ 
  #     "${config.virtualisation.oci-containers.backend}-mysql_source.service"
  #     "${config.virtualisation.oci-containers.backend}-mysql_target.service"
  #    ];
  #   script = ''
  #     ${pkgs.podman}/bin/podman pod exists testdb || ${pkgs.podman}/bin/podman pod create -p "127.0.0.1:3306:3307" testdb
  #   '';
  # };

  # virtualisation.oci-containers.containers = {
    # slave_db = {
    #   image = "mariadb:latest";
    #   ports = [ "3307:3306" ];
    #   cmd = [ "--server-id=2" ];
    #   # extraOptions = [ "--pod=testdb" ];
    #   environment = {
    #     MARIADB_RANDOM_ROOT_PASSWORD = "yes";
    #     MARIADB_DATABASE = "skynet";
    #     MARIADB_USER = "replication";
    #     MARIADB_PASSWORD = "dumbpassword";
    #   };
    # };
  #   mysql_target = {
  #     image = "mysql:latest";
  #     ports = [ "3307:3306" ];
  #     # extraOptions = [ "--pod=testdb" ];
  #     environment = {
  #       MYSQL_RANDOM_ROOT_PASSWORD = "yes";
  #       MYSQL_DATABASE = "skynet";
  #       MYSQL_USER = "cameron";
  #       MYSQL_PASSWORD = "dumbpassword";
  #     };
  #   };
  # };

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "wlp170s0";
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
  };

  containers.mysql-slave = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    config = { pkgs, lib, ... }: {
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        settings = {
          mariadb = {
            server-id = 2;
          };
        };
      };

      system.stateVersion = "23.05";

      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 3307 ];
        };
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };
      
      services.resolved.enable = true;
    };
  };
  # machinectl list
  # nixos-container root-login nextcloud
  # nixos-container start nextcloud
  # nixos-container stop nextcloud

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [
      "skynet_pkg"
      "skynet_ogi"
    ];
    ensureUsers = [
      {
        name = "backup";
        ensurePermissions = {
          "*.*" = "SELECT, LOCK TABLES";
        };
      }
      {
        name = "replication";
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
        };
      }
    ];
    settings = {
      mariadb = {
        log-bin = "binlog";
        server-id = 1;
        log-basename = "primary1";
        binlog-format = "mixed";
      };
    };
    initialScript = pkgs.writeText "mariaInit.sql" ''
    CREATE USER 'replication'@'%' IDENTIFIED BY 'dumbpassword';
    GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';
    '';
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 4 * * SUN        mysql   /var/backups/backup-db.sh backup --full"  # Weekly full backup on sunday
      "0 4 * * MON-SAT    mysql   /var/backups/backup-db.sh backup --incr"  # Daily incremental backups on other days
      # "0 * * * *            mysql   /var/backups/backup-db.sh backup --full"  # Hourly full backup
      # "15,30,45 * * * *     mysql   /var/backups/backup-db.sh backup --incr"  # Incremental backups every 15 minutes
    ];
  };
}