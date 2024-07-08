{ pkgs, lib, config, ... }:
let
  inherit (config.sops) secrets;
in {
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "605959e6";
}
