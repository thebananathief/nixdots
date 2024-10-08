{pkgs, config, ...}: {
  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.flags = [
        "--all"
      ];
    };
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
  };

  environment.systemPackages = with pkgs; [
    # podman-compose
    # dive
    # podman-tui
    mailutils
  ];

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

  virtualisation.oci-containers.containers = {
    slave_db = {
      image = "mariadb:latest";
      ports = [ "3307:3306" ];
      cmd = [ "--server-id=2" ];
      # extraOptions = [ "--pod=testdb" ];
      environment = {
        MARIADB_RANDOM_ROOT_PASSWORD = "yes";
        MARIADB_DATABASE = "skynet";
        MARIADB_USER = "replication";
        MARIADB_PASSWORD = "dumbpassword";
      };
    };
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
  };

  environment.sessionVariables = {
    MYSQL_RANDOM_ROOT_PASSWORD = "yes";
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    # initialDatabases = [
    #   {
    #     name = "skynet";
    #     schema = "skynet_pkg";
    #   }
    #   {
    #     name = "skynet";
    #     schema = "skynet_ogi";
    #   }
    # ];
    ensureDatabases = [
      "skynet_pkg"
      "skynet_ogi"
    ];
    ensureUsers = [
      {
        name = "cameron";
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
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
        server-id = 1;
      };
    };
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