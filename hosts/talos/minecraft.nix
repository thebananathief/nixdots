{ config, lib, pkgs, ... }:
with lib;
let
  serverPort = 25565;
  rconPort = 25575;

  jvmOpts = "-Xms4G -Xmx6G";
  # jvmOpts = "-Xms4G -Xmx4G -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
  forgeVersion = "1.20.1-47.1.84"; # This is used for downloads and filepaths, very important

  serverProperties = {
    motd = "The UPS Store";
    server-port = serverPort;
    difficulty = 3;
    gamemode = 0;
    max-players = 24;
    enable-rcon = true;
    "rcon.port" = rconPort;
    "rcon.password" = "stupidpassword";
  };

  eulaFile = builtins.toFile "eula.txt" ''
    # eula.txt managed by NixOS Configuration
    eula=true
  '';

  cfgToString = v: if builtins.isBool v then boolToString v else toString v;

  serverPropertiesFile = pkgs.writeText "server.properties" (''
    # server.properties managed by NixOS configuration
  '' + concatStringsSep "\n" (mapAttrsToList
    (n: v: "${n}=${cfgToString v}") serverProperties));

  stopScript = pkgs.writeShellScript "minecraft-server-stop" ''
    echo stop > ${config.systemd.sockets.minecraft-ups.socketConfig.ListenFIFO}

    # Wait for the PID of the minecraft server to disappear before
    # returning, so systemd doesn't attempt to SIGKILL it.
    while kill -0 "$1" 2> /dev/null; do
      sleep 1s
    done
  '';
in {
  users = {
    groups.minecraft = {};
    extraUsers.minecraft = {
      isSystemUser = true;
      group = "minecraft";
      home = "/mnt/ssd/gameservers/minecraft-ups";
      createHome = true;
      packages = with pkgs; [
        temurin-jre-bin-17
      ];
    };
  };

  systemd.sockets.minecraft-ups = {
    bindsTo = [ "minecraft-ups.service" ];
    socketConfig = {
      ListenFIFO = "/run/minecraft-ups.stdin";
      SocketMode = "0660";
      SocketUser = "minecraft";
      SocketGroup = "minecraft";
      RemoveOnStop = true;
      FlushPending = true;
    };
  };

  # TODO: Figure out how to get the modloader installed using the version number

  # https://neoforged.net/
  # wget https://maven.neoforged.net/releases/net/neoforged/forge/1.20.1-47.1.84/forge-1.20.1-47.1.84-installer.jar
  # java -jar <installer jar> --installServer
  # ./run.sh

  systemd.services.minecraft-ups = {
    enable = true;
    description = "Forge Minecraft Server";
    wantedBy      = [ "multi-user.target" ];
    requires      = [ "minecraft-ups.socket" ];
    after         = [ "network.target" "minecraft-ups.socket" ];
    serviceConfig = {
      WorkingDirectory = "${config.users.extraUsers.minecraft.home}";
      ExecStart = "${pkgs.temurin-jre-bin-17}/bin/java ${jvmOpts} @libraries/net/neoforged/forge/${forgeVersion}/unix_args.txt";
      ExecStop = "${stopScript} $MAINPID";
      Restart = "always";
      RestartSec = 60;
      User = "minecraft";

      StandardInput = "socket";
      StandardOutput = "journal";
      StandardError = "journal";

      # Hardening
      CapabilityBoundingSet = [ "" ];
      DeviceAllow = [ "" ];
      LockPersonality = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      UMask = "0077";
    };
    preStart = ''
      ln -sf ${eulaFile} eula.txt

      # Needs to be writable for us to overwrite
      chmod +w server.properties
      cp -f ${serverPropertiesFile} server.properties
    '';
  };

  networking.firewall = {
    allowedUDPPorts = [ serverPort ];
    allowedTCPPorts = [ serverPort ]
      ++ optional (rconPort != null) rconPort;
  };

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
