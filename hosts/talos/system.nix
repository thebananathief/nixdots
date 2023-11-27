{ pkgs, ... }: {
  imports = [
    ./fileshares.nix
    ./containers.nix
  ];

  networking = {
    hostName = "talos";
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };

#  environment.systemPackages = with pkgs; [
#  ];

  services.openssh = {
    enable = true;
    ports = [ 4733 ];
  };
  security.pam.enableSSHAgentAuth = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 443 4733 ];
#  networking.firewall.allowedUDPPorts = [ ]; # TODO: KF ports?

#Is this needed?
#  hardware.opengl = {
#    enable = true;
#    driSupport = true;
#    driSupport32Bit = true;
#    extraPackages = with pkgs; [ intel-media-driver ];
#  };

  nix.trustedUsers = [ "cameron" ];

  users.users.cameron = {
    isNormalUser = true;
    description = "Cameron";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "23.05";
}
