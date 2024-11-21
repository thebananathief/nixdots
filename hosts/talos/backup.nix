{ pkgs, config, lib, ... }:
let
  inherit (config.sops) secrets;
in {
  environment.systemPackages = with pkgs; [
    restic
  ];

  users.users.restic = {
    isNormalUser = true;
    # isSystemUser = true;
  };

  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  sops.secrets.restic_talos_backup = {};

  services.restic.backups = {
    cloud-backup = {
      timerConfig = {
        OnCalendar = "Mon..Sat *-*-* 05:00:00";
        Persistent = true;
      };
      user = "restic";
      repository = "sftp://user@[::1]:2222//srv/restic-repo";
      initialize = false;
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
    #   # # TODO: Curl healthcheck to indicate successful backup?
    #   # backupCleanupCommand = ''
    #   # '';
    };
  };
}