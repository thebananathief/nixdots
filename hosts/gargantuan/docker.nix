{pkgs, ...}: {
  virtualisation = {
    # oci-containers.backend = "docker";
    # docker = {
    #   enable = true;
    #   autoPrune.enable = true;
    #   autoPrune.flags = [
    #     "--all"
    #   ];
    # };
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
    #   dockerSocket.enable = true; # UNSAFE: This allows anyone in the "podman" group to gain root access - It also allows containers to do a bunch of stuff
      defaultNetwork.settings.dns_enabled = true;
      autoPrune.enable = true;
      autoPrune.flags = [
        "--all"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    dive
    podman-tui
  ];

  virtualisation.oci-containers.containers = {
    mysql_source = {
      image = "mysql:latest";
      ports = [ "3306:3306" ];
      extraOptions = [ "--network=testdb" ];
      environment = {
        MYSQL_RANDOM_ROOT_PASSWORD = "yes";
        MYSQL_DATABASE = "skynet";
        MYSQL_USER = "cameron";
        MYSQL_PASSWORD = "dumbpassword";
      };
    };
    mysql_target = {
      image = "mysql:latest";
      ports = [ "3307:3306" ];
      extraOptions = [ "--network=testdb" ];
      environment = {
        MYSQL_RANDOM_ROOT_PASSWORD = "yes";
        MYSQL_DATABASE = "skynet";
        MYSQL_USER = "cameron";
        MYSQL_PASSWORD = "dumbpassword";
      };
    };
  };
}