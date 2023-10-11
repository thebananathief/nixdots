{ pkgs, ... }: {
    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = "client";
    environment.systemPackages = [ pkgs.tailscale-systray ];
}