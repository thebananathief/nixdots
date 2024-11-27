{
  system ? "x86_64-linux",
  args ? {},
  nixos-modules,
  home-module
}: let
  specialArgs = argDefaults // args;
in nixpkgs.lib.nixosSystem {
  inherit system specialArgs;
  pkgs = nixpkgsCustom system;
  modules = nixos-modules ++ [
    ../modules/common
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hm-backup";
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.users."${username}" = home-module;
    }
  ];
}