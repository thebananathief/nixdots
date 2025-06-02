{ config, ... }:
let
  inherit (config.sops) secrets;
  cfg = config.services.syncthing
in {
  systemd.services.syncthing = {
    # Don't create default ~/Sync folder
    environment.STNODEFAULTFOLDER = "true";
    # serviceConfig = {
    #   AmbientCapabilities = "CAP_CHOWN";
    # };
  };

  # users.users.syncthing.extraGroups = [ "users" ];
  # users.users.cameron.extraGroups = [ "syncthing" ];

  networking.firewall = mkIf cfg.openDefaultPorts {
    allowedTCPPorts = [ 3484 ];
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    settings = {
      gui = {
        enabled = true;
        user = "cameron";
        password = "dumbpassword";
        theme = "black";
      };
      # listenAddresses = [
      #   # "default"
      #   "tcp4://100.64.252.67:22000"
      #   "quic4://100.64.252.67:22000"
      #   "tcp6://[fd7a:115c:a1e0::9f40:fc43]:22000"
      #   "quic6://[fd7a:115c:a1e0::9f40:fc43]:22000"
      # ];
      minHomeDiskFree = {
        unit = "%";
        value = 1;
      };
      devices = {
        "thoth" = { 
          id = "FL4PA2C-TU7WRKX-3CWOYAX-XCL3H7R-B56JGRM-6QRUG5S-DS45SX5-MXB5NA3"; 
          autoAcceptFolders = true;
        };
        "gargantuan" = { 
          id = "TL26MOK-2FG5QAK-N5VCC35-CX6FPZV-OITRZR3-U3HSFJ6-PGY3SIZ-VRZ2VQX";
          autoAcceptFolders = true;
        };
      };
      folders = {
        "Syncthing" = {
          id = "hzrjk-u4j2p";
          path = "/var/lib/syncthing/cameron";
          devices = [ "thoth" "gargantuan" ];
          # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          # ignorePerms = false;
          order = "random";
          versioning = {
            type = "trashcan";
            params = {
              cleanInterval = "3600";
              cleanoutDays = "90";
            };
          };


# (?d)Thumbs.db
# (?d)desktop.ini
# ~*
# *~.*
# *.crdownload
# *.sb-????????-??????
# (?d)*.tmp
# .venv
# __pycache__
# .git
# .obsidian/themes
# .obsidian/appearance.json
# .obsidian/workspace.json


        };
      };
    };
    # key = "/appdata/certs/syncthing/key.pem";
    # cert = "/appdata/certs/syncthing/cert.pem";
  };
}
