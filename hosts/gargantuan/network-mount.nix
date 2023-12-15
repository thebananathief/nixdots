{
  config,
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = [ pkgs.cifs-utils ];
  
  fileSystems."/mnt/talos/storage" = {
    device = "//talos/storage";
    fsType = "cifs";
    options = let
      automount_opts = "vers=3.0,uid=1000,gid=100,dir_mode=0755,file_mode=0755,mfsymlinks,nofail";
    in [
      "${automount_opts},credentials=${config.sops.secrets.smb-secrets.path}"
    ];
  };
}
