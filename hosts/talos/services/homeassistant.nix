{config, ...}: {
  services.home-assistant = {
    enable = true;
    config = {
      homeassistant = {
        name = "Home";
        # latitude = "!secret latitude";
        # longitude = "!secret longitude";
        # elevation = "!secret elevation";
        unit_system = "metric";
        temperature_unit = "F";
        time_zone = "America/New_York";
      };
      # feedreader.urls = [ "https://nixos.org/blogs.xml" ];
    };
  };

  services.caddy.virtualHosts = {
    "ha.${config.networking.fqdn}".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:8123
    '';
  };
}
