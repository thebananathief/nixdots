{ config, lib, ... }: {
  options = with lib; {
    tailscaleInterfaces = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Tailscale interfaces for Caddy to bind to.";
    };
    networking.publicDomain = mkOption {
      type = with types; str;
      default = null;
      description = "Public TLD";
    };
  };
}
