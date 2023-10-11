{ pkgs, ... }: {
    programs.tailscale.enable = true;
    programs.tailscale.useRoutingFeatures = "client";
    environment.systemPackages = with pkgs; [
      tailscale-systray
      #trayscale
    ];
}