{ config, username, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  
  # SMART
  services.smartd = {
    enable = true;
    # devices = [
    # ];
  };
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "localhost:9100"
              "icebox:9100"
            ];
          }
        ];
      }
    ];
    exporters.node = {
      enable = true;
      enabledCollectors = [
        # "smartctl"
        # "textfile"
      ];
      # extraFlags = [
      #   "--collector.textfile.directory=/var/lib/node_exporter/textfile_collector"
      # ];
    };
  };

  # Open firewall port for node_exporter
  networking.firewall.allowedTCPPorts = [ 9100 ];
}
