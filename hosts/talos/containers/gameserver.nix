{ config, ... }:
let
  containerCfg = config.myOptions.containers;
in {
  virtualisation.oci-containers.containers = {
    kf2 = {
      image = "kr0nus/kf2server:latest";
      volumes = [ "${ containerCfg.gameserverDir }/kf2:/data" ];
      ports = [
        "27015:27015/udp"
        "20560:20560/udp"
        "7777:7777/udp"
        "8078:8080/tcp"
      ];
      environment = {
        KF2_OPTS = "KF-BurningParis?Game=ZedternalReborn.WMGameInfo_Endless?difficulty=1";
      };
    };
    # gmod = {
    #   volumes = [ "${ containerCfg.gameserverDir }/gmod-darkrp:/home/gmod/server/garrysmod" ];
    #   ports = [
    #     "27015:27015/udp"
    #     "27020:27020/udp"
    #     "27005:27005/udp"
    #   ];
    # # ---------------------------
    #   image = "gameservermanagers/gameserver:gmod";
    # # ---------- OR USE ---------
    #   image = "ceifa/garrysmod:debian"; # https://hub.docker.com/r/ceifa/garrysmod
    #   environment = {
    #     PRODUCTION = 0;
    #     HOSTNAME = "Test server";
    #     MAXPLAYERS = 24;
    #     GAMEMODE = "sandbox";
    #     MAP = "gm_construct";
    #     PORT = 27015;
    #     GSLT = "B61E68BC995F555A5002D822CD66B25A";
    #     # ARGS = "";
    #   };
    # };
    # pufferpanel = {
    #   image = "pufferpanel/pufferpanel:latest";
    #   volumes = [
    #     "${ containerCfg.gameserverDir }/pufferpanel/config:/etc/pufferpanel"
    #     "${ containerCfg.gameserverDir }/pufferpanel/data:/var/lib/pufferpanel"
    #     "/var/run/docker.sock:/var/run/docker.sock" # TODO: migrate to podman socket
    #   ];
    #   # ports = [
    #   #   "8080:8080"
    #   #   "5657:5657"
    #   #   "27015:27015"
    #   # ];
    #   extraOptions = [
    #     "--network=host"
    #   ];
    # };
  };
}