{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {

  sops.secrets = {
    "gmod.env" = {
      group = config.virtualisation.oci-containers.backend;
      mode = "0440";
    };
  };

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
      # Leaving base assets within container, binding the ones we need to be editable
        "${ cfg.gameserverDir }/gmod/addons:/home/gmod/server/garrysmod/addons"
        "${ cfg.gameserverDir }/gmod/gamemodes:/home/gmod/server/garrysmod/gamemodes"
        "${ cfg.gameserverDir }/gmod/data:/home/gmod/server/garrysmod/data"
        "${ cfg.gameserverDir }/gmod/cache:/home/gmod/server/garrysmod/cache"
        "${ cfg.gameserverDir }/gmod/maps:/home/gmod/server/garrysmod/maps"
        "${ cfg.gameserverDir }/gmod/download:/home/gmod/server/garrysmod/download"
        "${ cfg.gameserverDir }/gmod/downloadlists:/home/gmod/server/garrysmod/downloadlists"
        "${ cfg.gameserverDir }/gmod/cfg/server.cfg:/home/gmod/server/garrysmod/cfg/server.cfg"
        "${ cfg.gameserverDir }/gmod/sv.db:/home/gmod/server/garrysmod/sv.db"
        # "${ cfg.gameserverDir }/gmod:/home/gmod/server/garrysmod"
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
      environmentFiles = [
        secrets."gmod.env".path # GSLT, AUTHKEY
      ];
      environment = {
        PRODUCTION = "0";
        HOSTNAME = "Absolute Roleplay - LAWLESS | FEW DLs | COOL WEPS | NO STAFF";
        MAXPLAYERS = "24";
        GAMEMODE = "darkrp";
        MAP = "rp_downtown_tits_v2";
        PORT = "27015";
        # GSLT = "";
        # AUTHKEY = "";
        ARGS = "+host_workshop_collection 1173671290 -secure -tvdisable -conclearlog -condebug -console -conlog";
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
