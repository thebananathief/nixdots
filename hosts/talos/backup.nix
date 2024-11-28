{ pkgs, config, lib, ... }:
let
  inherit (config.sops) secrets;
in {
  environment.systemPackages = with pkgs; [
    restic
  ];

  # users.users.restic = {
  #   isNormalUser = true;
  #   description = "System user for transferring backups to icebox via SSH/SFTP";
  #   # isSystemUser = true;
  # };

  # security.wrappers.restic = {
  #   source = "${pkgs.restic.out}/bin/restic";
  #   owner = "restic";
  #   group = "users";
  #   permissions = "u=rwx,g=,o=";
  #   capabilities = "cap_dac_read_search=+ep";
  # };

  environment.shellAliases = {
    checkbackups = "sudo restic -r sftp:restic@icebox://mnt/backup/talos -p ${secrets.restic_talos_backup.path} snapshots";
  };

  sops.secrets.restic_talos_backup = {};
  sops.secrets.restic_talos_healthcheck = {};

  services.restic.backups = {
    icebox-backup = {
      timerConfig = {
        OnCalendar = "05:00:00";
        Persistent = true;
      };
      # user = "restic";
      repository = "sftp://restic@icebox:22//mnt/backup/talos";
      initialize = true;
      passwordFile = secrets.restic_talos_backup.path;
      paths = [ "/mnt/storage/media/family" ];
      exclude = [
        "*.tmp"
        "*.temp"
        "desktop.ini"
        "Thumbs.db"
        "*.crdownload"
        "*.sb-????????-??????"
        ".git"
      ];
    #   pruneOpts = [
    #     "--keep-last 5"
    #   ];
    #   # backupPrepareCommand = ''
    #   # '';
      backupCleanupCommand = ''
        ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$(< ${secrets.restic_talos_healthcheck.path})
      '';
    };
  };
}