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
        scrape_interval = "1m";
        scrape_timeout = "10s";
        static_configs = [
          {
            targets = [
              "localhost:9100"
              "icebox:9100"
              "icebox:9633"
            ];
          }
        ];
      }
    ];
    exporters.smartctl = {
      enable = true;
      maxInterval = "60s";
    };
    exporters.node = {
      enable = true;
    };
  };
}
