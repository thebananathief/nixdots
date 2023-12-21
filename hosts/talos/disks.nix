{ 
  pkgs,
  config,
  ...
}:
let
  inherit (config.sops) secrets;
in {
  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
    xfsprogs
    smartmontools
  ];
  
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
    device = "/dev/disk/by-uuid/bb0b2728-3662-4fef-b862-5f1be6d54172";
    fsType = "ext4";
  };
  # fileSystems."/mnt/disk4" = {
  #   device = "/dev/disk/by-uuid/db4a98ac-3a13-4a49-a40e-10a06f2db023";
  #   fsType = "";
  # };
  fileSystems."/mnt/parity1" = {
    device = "/dev/disk/by-uuid/a0f9bda4-acf6-4c9e-af77-8d11c7a10741";
    fsType = "xfs";
  };

  # MergerFS pool
  # Make sure the device defines the mountpoints you want to merge
  # (anything starting with "disk" in /mnt/)
  fileSystems."/mnt/storage" = {
    device = "/mnt/disk*:/mnt/tank/fuse";
    fsType = "fuse.mergerfs";
    options = [
      "defaults"
      "nonempty"
      "allow_other"
      "category.create=epmfs"
      "use_ino"
      "moveonenospc=true"
      "dropcacheonclose=true"
      "minfreespace=50G"
      "fsname=mergerfs"
    ];
  };

  services.snapraid = {
    enable = true;
    sync.interval = "02:00";
    scrub.interval = "Mon *-*-* 03:00:00";
    scrub.olderThan = 10; # Number of days since data was last scrubbed before it can be scrubbed again
    scrub.plan = 8; # Percent of the array that should be checked
    # Where to keep indexes? Ideally at least 2 drives
    contentFiles = [
      "/var/snapraid.content"
      "/mnt/parity1/snapraid.content"
      "/mnt/disk1/snapraid.content"
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

  sops.secrets.healthcheck_snapraid_uuid = {
    group = "users";
    mode = "0440";
  };

  # This is my attempt to add a healthcheck ping to the snapraid-sync
  # service that services.snapraid creates.
  systemd.services.snapraid-sync.postStart = ''
    curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$(< ${secrets.healthcheck_snapraid_uuid.path})
  '';
  
  # TODO: Need to have disk SMART alerts sent to me over email
  # Also reminders to buy drives
}