{ config, pkgs, ... }:
{
  # SMART
  services.smartd = {
    enable = true;
    # devices = [
    # ];
  };
  services.prometheus.exporters = {
    node = {
      enable = true;
      openFirewall = true;
      # port 9100
    };
    smartctl = {
      enable = true;
      maxInterval = "60s";
      openFirewall = true;
      # port 9633
    };
  };
}