{ ... }:
let
  jvmOpts = "-Xms4G -Xmx4G -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
in {
  users = {
    groups.minecraft = {};
    extraUsers.minecraft = {
      isSystemUser = true;
      group = "minecraft";
      home = "/var/minecraft-ups";
      createHome = true;
      packages = with pkgs; [
        temurin-jre-bin-17
      ];
    };
  };

  # systemd.services.minecraft = {
  #   enable = true;
  #   description = "Forge Minecraft Server";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.temurin-jre-bin-17}/bin/java ${jvmOpts} -jar ./forge.jar nogui";
  #     WorkingDirectory = "${config.users.extraUsers.minecraft.home}/forge";
  #     Restart = "always";
  #     RestartSec = 60;
  #   };
  #   after = [ "network.target" ];
  #   wantedBy = [ "default.target" ];
  # };
  #
  # networking.firewall.allowedTCPPorts = [ <portA> <portB> ];
  # networking.firewall.allowedUDPPorts = [ <portA> <portB> ];

  # services = {
  #   minecraft-server = {
  #     enable = true;
  #     eula = true;
  #     openFirewall = true;
  #     declarative = true;
  #     dataDir = "/mnt/ssd/gameservers/minecraft-ups";
  #     serverProperties = {
  #       motd = "The UPS Store";
  #       server-port = 25565;
  #       difficulty = 3;
  #       gamemode = 0;
  #       max-players = 24;
  #       enable-rcon = true;
  #       "rcon.port" = 25575;
  #       "rcon.password" = "stupidpassword";
  #     };
  #   };
  # };
}
