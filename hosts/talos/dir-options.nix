{ config, lib, ... }: {
  options = with lib; {
    tailscaleInterfaces = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Tailscale interfaces for Caddy to bind to.";
    };
  };
}
