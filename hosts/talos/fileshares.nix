{ ... }: {
  # https://nixos.wiki/wiki/Samba

  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  services.samba = {
    enable = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        security = "user";
        "server role" = "standalone server";
        "map to guest" = "bad user";

        # log file = /var/log/samba/%m.log
        # log level = 1
        # max log size = 50

        # server string = smbnix
        # netbios name = smbnix
        # security = user
        # use sendfile = yes
        # max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        # hosts allow = 192.168.0. 127.0.0.1 localhost
        # hosts deny = 0.0.0.0/0
        # guest account = nobody
      };
      home = {
        path = "/home/cameron";
        browseable = "yes";
        "read only" = "no";
        "inherit permissions" = "yes";
      };
      storage = {
        path = "/mnt/storage";
        browseable = "yes";
        "read only" = "no";
        "inherit permissions" = "yes";
      };
      gameservers = {
        path = "/mnt/ssd/gameservers";
        browseable = "yes";
        "read only" = "no";
        "inherit permissions" = "yes";
      };
      appdata = {
        path = "/appdata";
        browseable = "yes";
        "read only" = "no";
        "inherit permissions" = "yes";
      };
    };
    openFirewall = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      5357 # wsdd
    ];
    allowedUDPPorts = [
      3702 # wsdd
    ];
  };

  # Add a samba user with
  # sudo smbpasswd -a <user>



  # ----- CLIENT SIDE CIFS CONFIG -----
  # This is a mount for the client-side (if you wanted to connect a client to these fileshares)
  # environment.systemPackages = [ pkgs.cifs-utils ];

  # fileSystems."/mnt/storage" = {
  #   device = "//talos/storage";
  #   fsType = "cifs";
  #   options = let
  #     # this line prevents hanging on network split
  #     automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #   in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=1000"];
  # };

  # Make sure to create /etc/nixos/smb-secrets with structure:
  #   username=<USERNAME>
  #   domain=<DOMAIN>
  #   password=<PASSWORD>

  # networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  # ----- CLIENT SIDE CIFS CONFIG -----
}
