{ config, lib, pkgs, ... }:
with lib;
let {
  serverPort = 25565;
  rconPort = 25575;
  
  services.minecraft-server = {
    enable = true;
    eula = true;
    serverProperties = {
      motd = "Kappa";
      server-port = serverPort;
      difficulty = 3;
      gamemode = 0;
      max-players = 24;
      enable-rcon = false;
      "rcon.port" = rconPort;
      "rcon.password" = "stupidpassword";
    };
  };
}
