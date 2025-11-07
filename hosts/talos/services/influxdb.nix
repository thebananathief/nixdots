{config, pkgs, sops, ...}: let
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    influx_db_pass = {
      owner = config.users.users.influxdb2.name;
      group = config.users.users.influxdb2.group;
      mode = "0400";
    };
    influx_db_token = {
      owner = config.users.users.influxdb2.name;
      group = config.users.users.influxdb2.group;
      mode = "0400";
    };
  };

  services.influxdb2 = {
    enable = true;

    provision = {
      enable = true;

      initialSetup = {
        username = "cameron";
        passwordFile = secrets.influx_db_pass.path;
        tokenFile = secrets.influx_db_token.path;
        organization = "myorg";
        bucket = "mybucket";
        retention = 31536000; # 1 year
      };

      # users = {
      #   cameron = {
      #     passwordFile = secrets.influx_db_pass.path;
      #     org = "myorg";
      #     bucket = "mybucket";
      #   };
      # };

      # organizations = {
      #   myorg = {
      #     description = "My organization";
      #     buckets.mybucket = {
      #       description = "My bucket";
      #       retention = 31536000; # 1 year
      #     };
      #   };
      # };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8086 ];
}