{ config, pkgs, lib, ... }:

let
in
{
  virtualisation.oci-containers.containers = {
    perses = {
      image = "persesdev/perses:latest";
      pull = "newer";
      ports = [ "8018:8080" ];
    };
  };

  services.caddy.virtualHosts = {
    "perses.${config.networking.fqdn}".extraConfig = ''
      @denied not remote_ip private_ranges
      abort @denied

      tls internal
      reverse_proxy localhost:8018
    '';
  };
}