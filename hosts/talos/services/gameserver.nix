{ config, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
  gameserverDir = "/mnt/ssd/gameservers";
in {

  sops.secrets = {
    # "gmod.env" = {
    #   group = config.virtualisation.oci-containers.backend;
    #   mode = "0440";
    # };
  };

  virtualisation.oci-containers.containers = {
    kf2 = {
      image = "kr0nus/kf2server:latest";
      volumes = [ "${ gameserverDir }/kf2:/data" ];
      ports = [
        "27015:27015/udp"
        "20560:20560/udp"
        "7777:7777/udp"
        "8012:8080/tcp"
      ];
      environment = {
        KF2_OPTS = "KF-BurningParis?Game=ZedternalReborn.WMGameInfo_Endless?difficulty=1";
      };
      extraOptions = [
        "--ip=172.17.0.7"
      ];
    };
    
    # gmod = {
    #   image = "gameservermanagers/gameserver:gmod";
    
    # --------------------
    
      # image = "ceifa/garrysmod:debian"; # https://hub.docker.com/r/ceifa/garrysmod
      # volumes = [
      # Leaving base assets within container, binding the ones we need to be editable
        # "${ gameserverDir }/gmod/addons:/home/gmod/server/garrysmod/addons"
        # "${ gameserverDir }/gmod/gamemodes:/home/gmod/server/garrysmod/gamemodes"
        # "${ gameserverDir }/gmod/data:/home/gmod/server/garrysmod/data"
        # "${ gameserverDir }/gmod/cache:/home/gmod/server/garrysmod/cache"
        # "${ gameserverDir }/gmod/maps:/home/gmod/server/garrysmod/maps"
        # "${ gameserverDir }/gmod/download:/home/gmod/server/garrysmod/download"
        # "${ gameserverDir }/gmod/downloadlists:/home/gmod/server/garrysmod/downloadlists"
        # "${ gameserverDir }/gmod/cfg/server.cfg:/home/gmod/server/garrysmod/cfg/server.cfg"
        # "${ gameserverDir }/gmod/sv.db:/home/gmod/server/garrysmod/sv.db"
        # "${ gameserverDir }/gmod:/home/gmod/server/garrysmod"
      # ];
      # ports = [
      #   "27015:27015"
      #   "27015:27015/udp"
      #   "27005:27005/udp"
        # "27020:27020/udp"
      # ];
    #   environmentFiles = [
    #     secrets."gmod.env".path # GSLT, AUTHKEY
    #   ];
    #   environment = {
    #     PRODUCTION = "0";
    #     HOSTNAME = "Absolute Roleplay - LAWLESS | FEW DLs | COOL WEPS | NO STAFF";
    #     MAXPLAYERS = "24";
    #     GAMEMODE = "darkrp";
    #     MAP = "rp_downtown_tits_v2";
    #     PORT = "27015";
    #     # GSLT = "";
    #     # AUTHKEY = "";
    #     ARGS = "+host_workshop_collection 1173671290 -secure -tvdisable +sv_lan 0";
    #   };
    # };
    # pufferpanel = {
    #   image = "pufferpanel/pufferpanel:latest";
    #   volumes = [
    #     "${ gameserverDir }/pufferpanel/config:/etc/pufferpanel"
    #     "${ gameserverDir }/pufferpanel/data:/var/lib/pufferpanel"
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
