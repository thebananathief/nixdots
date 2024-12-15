{ config, username, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  
  services.grafana = {
    enable = true;
    settings.server.http_addr = "0.0.0.0";
    settings.server.http_port = 3000;
  };

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
        job_name = "talos";
        scrape_interval = "1m";
        scrape_timeout = "10s";
        static_configs = [
          {
            targets = [
              "localhost:9100"
              "localhost:9633"
            ];
          }
        ];
      }
      {
        job_name = "icebox";
        scrape_interval = "1m";
        scrape_timeout = "10s";
        static_configs = [
          {
            targets = [
              "icebox:9100"
              "icebox:9633"
            ];
          }
        ];
      }
    ];
    exporters.node = {
      enable = true;
    };
    exporters.smartctl = {
      enable = true;
      maxInterval = "60s";
    };
  };

  
  services.caddy.virtualHosts = {
    "grafana.${ config.networking.fqdn }".extraConfig = ''
      tls /var/lib/caddy/.local/share/caddy/keys/talos.host.pem /var/lib/caddy/.local/share/caddy/keys/talos.host.key

      @authorized remote_ip 192.168.0.0/24
      handle @authorized {
        reverse_proxy localhost:3000
      }
      handle {
        respond "Unauthorized" 403
      }
    '';
  };
}
