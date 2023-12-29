{ ... }:
{
  services = {
    minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true;
      declarative = true;
      dataDir = "/mnt/ssd/gameservers/minecraft-ups";
      serverProperties = {
        motd = "The UPS Store";
        server-port = 25565;
        difficulty = 3;
        gamemode = 0;
        max-players = 24;
        enable-rcon = true;
        "rcon.port" = 25575;
        "rcon.password" = "stupidpassword";
      };
    };
  };
}