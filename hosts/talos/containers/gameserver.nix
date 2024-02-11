{ config, ... }:
let
  cfg = config.myOptions.containers;
in {
  virtualisation.oci-containers.containers = {
    # kf2 = {
    #   image = "kr0nus/kf2server:latest";
    #   volumes = [ "${ cfg.gameserverDir }/kf2:/data" ];
    #   ports = [
    #     "27015:27015/udp"
    #     "20560:20560/udp"
    #     "7777:7777/udp"
    #     "8012:8080/tcp"
    #   ];
    #   environment = {
    #     KF2_OPTS = "KF-BurningParis?Game=ZedternalReborn.WMGameInfo_Endless?difficulty=1";
    #   };
    #   extraOptions = [
    #     "--ip=172.17.0.7"
    #   ];
    # };
    gmod = {
      volumes = [
        "${ cfg.gameserverDir }/gmod/addons:/home/gmod/server/garrysmod/addons"
        "${ cfg.gameserverDir }/gmod/gamemodes:/home/gmod/server/garrysmod/gamemodes"
        "${ cfg.gameserverDir }/gmod/data:/home/gmod/server/garrysmod/data"
        "${ cfg.gameserverDir }/gmod/cfg/server.cfg:/home/gmod/server/garrysmod/cfg/server.cfg"
      ];
      ports = [
        "27015:27015"
        "27015:27015/udp"
        "27005:27005/udp"
        "27020:27020/udp"
      ];
    # # ---------------------------
    #   image = "gameservermanagers/gameserver:gmod";
    # # ---------- OR USE ---------
      image = "ceifa/garrysmod:debian"; # https://hub.docker.com/r/ceifa/garrysmod
      environment = {
        PRODUCTION = "0";
        HOSTNAME = "Absolute Roleplay - LAWLESS | FEW DLs | COOL WEPS | NO STAFF";
        MAXPLAYERS = "24";
        GAMEMODE = "darkrp";
        MAP = "rp_downtown_tits_v2";
        PORT = "27015";
        GSLT = "***REMOVED***";
        ARGS = "+host_workshop_collection 1173671290 -authkey ***REMOVED***";
      };
    };
    # pufferpanel = {
    #   image = "pufferpanel/pufferpanel:latest";
    #   volumes = [
    #     "${ cfg.gameserverDir }/pufferpanel/config:/etc/pufferpanel"
    #     "${ cfg.gameserverDir }/pufferpanel/data:/var/lib/pufferpanel"
    #     "/var/run/docker.sock:/var/run/docker.sock"
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
