{ pkgs, lib, config, ... }:
let
  inherit (config.sops) secrets;
in {
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
}
