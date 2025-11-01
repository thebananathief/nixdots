{ config, ... }:

{
  services.smokeping = {
    enable = true;
    webService = true;
    # Listen on all interfaces; set to "127.0.0.1" for localhost only
    host = null;
    port = 8015;
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
}