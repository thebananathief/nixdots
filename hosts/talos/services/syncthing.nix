{ config, ... }:
let
  inherit (config.sops) secrets;
in {
  # sops.secrets = {
  #   "mullvad.env" = {
  #   group = config.virtualisation.oci-containers.backend;
  #   mode = "0440";
  #   };
  # };

  # Don't create default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      # gui = {
      #   user = "myuser";
      #   password = "mypassword";
      # };
      devices = {
        "thoth" = { 
          id = "FL4PA2C-TU7WRKX-3CWOYAX-XCL3H7R-B56JGRM-6QRUG5S-DS45SX5-MXB5NA3"; 
          autoAcceptFolders = true;
        };
        # "gargantuan" = { 
        #   id = "DEVICE-ID-GOES-HERE";
        #   autoAcceptFolders = true;
        # };
      };
      folders = {
        "Syncthing" = {
          id = "hzrjk-u4j2p";
          path = "/home/cameron/Syncthing";
          devices = [ "thoth" ];
          # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          # ignorePerms = false;
          # Tries to copy file/folder ownership from the parent directory
          copyOwnershipFromParent = true;
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
