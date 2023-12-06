{ ... }:
{
  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
    xfsprogs
    smartmontools
  ];

  snapraid = {
    enable = true;
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

  # This is my attempt to add a healthcheck ping to the snapraid-sync
  # service that services.snapraid creates.
  systemd.services.snapraid-sync.serviceConfig.postStart = ''
    curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/${ healthcheck_snapraid_uuid }
  '';

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

  
  # TODO: Need to have disk SMART alerts sent to me over email
  # Also reminders to buy drives
}