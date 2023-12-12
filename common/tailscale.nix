{ pkgs, lib, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
    # authKeyFile = "/run/secrets/tailscale_key";
    # authKeyFile required for the extraUpFlags attr
    # extraUpFlags = [
      # "--advertise-routes=192.168.0.0/24"
      # "--advertise-exit-node"
    # ];
  };
  environment.systemPackages = with pkgs; [ 
    tailscale
    tailscale-systray
  ];
}
