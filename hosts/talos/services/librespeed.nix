{ config, ... }:
let
  cfg = config.myOptions.containers;
in {
  virtualisation.oci-containers.containers = {
    librespeed = {
      image = "lscr.io/linuxserver/librespeed:latest";
      volumes = [
        "${ cfg.dataDir }/librespeed:/config"
      ];
      environment = {
        PASSWORD = "PASSWORD";
      } // cfg.common_env;
      ports = [ "8016:80" ];
    };
  };
}
