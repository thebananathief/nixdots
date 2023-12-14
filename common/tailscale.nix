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
  # networking.firewall.checkReversePath = "loose";
  # networking.nameservers = [ "100.100.100.100" "1.1.1.1" "8.8.8.8" ];
  # networking.search = [ "johnreillymurray.gmail.com.beta.tailscale.net" ];
}
