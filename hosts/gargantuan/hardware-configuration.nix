# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    loader = {
      #systemd-boot = {
      #  enable = true;
      #  configurationLimit = 30;
      #  consoleMode = "max";
      #};
      efi.canTouchEfiVariables = true;
      #efi.efiSysMountPoint = "/boot/efi";
      grub = {
        enable = true;
        #splashImage = "";
        #useOSProber = true;
        device = "nodev";
        efiSupport = true;
        #theme = pkgs.libsForQt5.breeze-grub;
        fontSize = 48;
        #extraConfig = "set theme=${pkgs.libsForQt5.breeze-grub}/themes/breeze/theme.txt";
      };
    };
    #plymouth = {
      #enable = true;
      #theme = "breeze";
    #};
    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };


  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2a2620cf-a5c5-410d-94f8-83c51b1bf162";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C797-96B9";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
