{ config, pkgs, ... }:
{
  # SMART
  services.smartd = {
    enable = true;
    # devices = [
    # ];
  };
  services.prometheus.exporters.node = {
    enable = true;
    # openFirewall = true;
    enabledCollectors = [
      "smartctl"
      "textfile"
    ];
    extraFlags = [
      "--collector.textfile.directory=/var/lib/node_exporter/textfile_collector"
    ];
  };
}