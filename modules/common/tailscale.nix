{ pkgs, lib, username, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
    # authKeyFile = "/run/secrets/tailscale_key";
    # authKeyFile required for the extraUpFlags attr
    extraUpFlags = [
      "--ssh"
      "--operator=${username}"
      # "--advertise-routes=192.168.0.0/24"
      # "--advertise-exit-node"
      "--reset" # prevents error on autoconnect service when I change these options
    ];
  };
  environment.systemPackages = with pkgs; [
    tailscale
  ];
  # networking.firewall.checkReversePath = "loose";
  # networking.nameservers = [ "100.100.100.100" "1.1.1.1" "8.8.8.8" ];
  # networking.search = [ "johnreillymurray.gmail.com.beta.tailscale.net" ];
}
