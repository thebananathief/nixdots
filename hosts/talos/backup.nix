{ pkgs, config, lib, ... }:
let
  inherit (config.sops) secrets;
in {
  environment.systemPackages = with pkgs; [
    restic
  ];

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
      repository = "sftp://restic@icebox:22//mnt/backup/talos";
      initialize = true;
      passwordFile = secrets.restic_talos_backup.path;
      paths = [
        "/mnt/storage/media/family"
        "/mnt/storage/media/books"
        "/mnt/storage/media/games"
        "/mnt/storage/programs"
        "/mnt/ssd/gameservers/gmod"
        "/mnt/ssd/gameservers/kf2/KFGame/Config"
        "/var/lib/minecraft/world"
        "/var/lib/private/jellyseerr"
        "/var/lib/jellyfin"
        "/appdata"
      ];
      exclude = [
        "*.tmp"
        "*.temp"
        "desktop.ini"
        "Thumbs.db"
        "*.crdownload"
        "*.sb-????????-??????"
        ".git"
      ];
      pruneOpts = [
        "--keep-last 10"
        "--keep-monthly 12"
      ];
      backupCleanupCommand = ''
        ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$(< ${secrets.restic_talos_healthcheck.path})
      '';
    };
  };
}
