{ config, lib, pkgs, ... }:
with lib;
let 
in {
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    # package = ;
    serverProperties = {
      motd = "Kappa";
      difficulty = 3;
      gamemode = 0;
      max-players = 24;
      enable-rcon = false;
      server-port = 25565;
      "rcon.port" = 25575;
      "rcon.password" = "stupidpassword";
    };
  };
}
