{config, pkgs, sops, ...}: let
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    influx_db_pass = {neededForUsers = true;};
  };

  services.influxdb2 = {
    enable = true;

    provision = {
      enable = true;

      users = {
        cameron = {
          passwordFile = secrets.influx_db_pass.path;
          org = "myorg";
          bucket = "mybucket";
        };
      };

      organizations = {
        myorg = {
          description = "My organization";
          buckets.mybucket = {
            description = "My bucket";
            retention = 31536000; # 1 year
          };
        };
      }
    }
  };

  networking.firewall.allowedTCPPorts = [ 8086 ];
}