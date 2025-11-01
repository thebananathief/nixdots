{ config, ... }:

{
  services.smokeping = {
    enable = true;
    webService = true;
    targetConfig = ''
      probe = FPing
      menu = Top
      title = Network Latency Grapher
      remark = TALOS SmokePing.

      + Global
      menu = Global
      title = Global services

      ++ CloudFlare
      host = www.cloudflare.com

      ++ Google
      host = www.google.com

      + Local
      menu = Local
      title = Local Network

      ++ LocalMachine
      menu = Local Machine
      title = This host
      host = localhost
    '';
  };

  services.nginx.virtualHosts.smokeping.listen = [
    {
      addr = "localhost";
      port = 8017;
    }
  ];
  services.caddy.virtualHosts = {
    "smokeping.${config.networking.fqdn}".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:8017
    '';
  };
}