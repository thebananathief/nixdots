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
  systemd.services.syncthing = {
    environment.STNODEFAULTFOLDER = "true";
    # serviceConfig = {
    #   AmbientCapabilities = "CAP_CHOWN";
    # };
  };

  # users.users.syncthing.extraGroups = [ "users" ];
  # users.users.cameron.extraGroups = [ "syncthing" ];
  # systemd.services.syncthing.serviceConfig.UMask = "0007";
  # systemd.tmpfiles.rules = [
  #   "d /home/cameron 0750 cameron syncthing"
  # ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      # gui = {
        # enabled = true;
      #   user = "myuser";
      #   password = "mypassword";
      #   theme = "black";
      # };
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
        # "gargantuan" = { 
        #   id = "DEVICE-ID-GOES-HERE";
        #   autoAcceptFolders = true;
        # };
      };
      folders = {
        "Syncthing" = {
          id = "hzrjk-u4j2p";
          path = "/var/lib/syncthing/cameron";
          # path = "/home/cameron/syncthing";
          devices = [ "thoth" ];
          # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          # ignorePerms = false;
          # Tries to copy file/folder ownership from the parent directory
          # copyOwnershipFromParent = true;
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
