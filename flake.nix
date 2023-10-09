{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs:
    let
      system = builtins.currentSystem;
      defaultModules = [
        { _module.args = { inherit inputs; }; }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
      mkPkgs = system:
        import nixpkgs {
          config.allowUnfree = true;
        };
      mkSystem = extraModules:
        nixpkgs.lib.nixosSystem rec {
          pkgs = mkPkgs system;
          system = "x86_64-linux";
          modules = defaultModules ++ extraModules;
        };
    in {
      lib = { inherit mkSystem; };
      nixosModules.default = { ... }: {
        imports = defaultModules ++ [ ./common ];
      };
      nixosConfigurations.gargantuan = mkSystem [
        ./hosts/gargantuan
        nixos-hardware.nixosModules.framework
      ];
    };
}
