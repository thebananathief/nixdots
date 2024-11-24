{ config, ... }:
let
  cfg = config.myOptions.containers;
in {
  virtualisation.oci-containers.containers = {
    grist = {
      image = "gristlabs/grist:latest";
      volumes = [
        "${ cfg.dataDir }/grist/persist:/persist"
      ];
      ports = [ "8484:8484" ];
    };
  };
}




