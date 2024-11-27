{ pkgs, config, lib, ... }:
let
  inherit (config.sops) secrets;
in {
  sops.secrets.restic_talos_backup = {};

  users.users.restic = {
    isNormalUser = true;
    description = "System user for transferring backups to this host via SSH/SFTP";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBWMKIWlPqXgsNT5Wqd2vw6JrdI8sagF8x2dfw9W+NVd restic-backup"
    ];
  };

  # services.restic = {
  #   server = {
  #     enable = true;
  #     dataDir = "${vars.mainArray}/Backups/restic";
  #     extraFlags = [
  #       "--no-auth"
  #     ];
  #   };
  # };
}