{ config, ... }:
let
  inherit (config.sops) secrets;
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

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "cameron";
    configDir = "/home/cameron/.config/syncthing";
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
        "talos" = { 
          id = "LVMNARK-NWA2EAF-TSDBBN4-Z4ISEX4-M444JKC-UINGPNL-3MY2MVN-JNELLAU";
          autoAcceptFolders = true;
        };
      };
      folders = {
        "Syncthing" = {
          id = "hzrjk-u4j2p";
          path = "/home/cameron/Syncthing";
          devices = [ "thoth" "talos" ];
          # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          ignorePerms = true;
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
