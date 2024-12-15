{ pkgs, lib, config, ... }:
let
  inherit (config.sops) secrets;
in {
  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
    xfsprogs
    smartmontools
  ];
  
  # ZFS stuff
  boot.supportedFilesystems = [
    "ext4"
    "xfs"
    "fat"
    "exfat"
    # "btrfs"
    # "zfs"
    # "ntfs"
    # "vfat"
    # "cifs" # mount windows share
  ];
  
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  # boot.zfs.forceImportRoot = false;
  # networking.hostId = "605959e6";

  # Storage/Parity drives
  fileSystems."/mnt/disk1" = {
    device = "/dev/disk/by-uuid/16165a4b-d650-4a84-a55d-9db8f83d0271";
    fsType = "ext4";
  };
  fileSystems."/mnt/disk2" = {
    device = "/dev/disk/by-uuid/cec3736e-cfa9-40e4-8143-02b338cd75e9";
    fsType = "xfs";
  };
  fileSystems."/mnt/disk3" = {
    device = "/dev/disk/by-uuid/1236c154-8c20-4e12-8e28-da62db223074";
    fsType = "xfs";
  };
  fileSystems."/mnt/used1" = {
    device = "/dev/disk/by-uuid/bb0b2728-3662-4fef-b862-5f1be6d54172";
    fsType = "ext4";
  };
  # Not installed atm
  # fileSystems."/mnt/disk4" = {
  #   device = "/dev/disk/by-uuid/db4a98ac-3a13-4a49-a40e-10a06f2db023";
  #   fsType = "";
  # };
  fileSystems."/mnt/parity1" = {
    device = "/dev/disk/by-uuid/a0f9bda4-acf6-4c9e-af77-8d11c7a10741";
    fsType = "xfs";
  };

  # MergerFS pool
  # This globs all mounts at /mnt/disk* into a single mountpoint: /mnt/storage
  fileSystems."/mnt/storage" = {
    device = "/mnt/disk*:/mnt/tank/fuse";
    fsType = "fuse.mergerfs";
    options = [
      # "defaults"
      # "nonempty"
      "cache.files=partial"
      "category.create=mfs"
      "moveonenospc=true"
      "dropcacheonclose=true"
      "minfreespace=30G"
      "fsname=mergerfs"
    ];
  };

  # systemd.services.snapraid-sync.enable = false;
  # systemd.services.snapraid-scrub.enable = false;
  
  services.snapraid = {
    enable = true;
    sync.interval = "05:00";
    scrub.interval = "Mon *-*-* 06:00:00";
    scrub.olderThan = 10; # Number of days since data was last scrubbed before it can be scrubbed again
    scrub.plan = 8; # Percent of the array that should be checked
    # Where to keep indexes? Ideally at least 2 drives
    contentFiles = [
      "/var/snapraid.content"
      "/mnt/parity1/snapraid.content"
      "/mnt/disk2/snapraid.content"
    ];
    parityFiles = [
      "/mnt/parity1/snapraid.parity"
    ];
    dataDisks = {
      d1 = "/mnt/disk1";
      d2 = "/mnt/disk2";
      d3 = "/mnt/disk3";
    };
    exclude = [
      "*.unrecoverable"
      "/tmp/"
      "/lost+found/"
      "appdata/"
      "downloads/"
      "*.!sync"
      ".AppleDouble"
      "._AppleDouble"
      ".DS_Store"
      "._.DS_Store"
      ".Thumbs.db"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".AppleDB"
      ".nfo"
    ];
  };

  # Add a healthcheck to make sure snapraid syncs every night
  sops.secrets.healthcheck_snapraid_uuid = {
    group = "users";
    mode = "0440";
  };

  systemd.services.snapraid-sync = {
    postStart = ''
      ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$(< ${secrets.healthcheck_snapraid_uuid.path})
    '';
    serviceConfig = {
        # snapraid.nix module disables all address families, so we re-enable them here so that we can ping hc-ping.com
        RestrictAddressFamilies = lib.mkForce [ "AF_INET" "AF_INET6" ];
    };
  };
}
