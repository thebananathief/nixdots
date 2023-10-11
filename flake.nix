{
  description = "NixOS configuration";

  nixConfig = { experimental-features = [ "nix-command" "flakes" ]; };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      defaultModules = [
        { _module.args = { inherit inputs; }; }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.cameron = import ./home/cameron;
        }
        ./common
      ];
      mkPkgs = import nixpkgs {
        config.allowUnfree = true;
        inherit system;
      };
      mkSystem = extraModules:
        nixpkgs.lib.nixosSystem rec {
          pkgs = mkPkgs;
          system = "x86_64-linux";
          modules = defaultModules ++ extraModules;
        };
    in {
      #lib = { inherit mkSystem; };
      # nixosModules.default = { ... }: {
      #   imports = defaultModules ++ [ ./common ];
      # };
      nixosConfigurations.gargantuan = mkSystem [
        ./hosts/gargantuan
        nixos-hardware.nixosModules.framework
        # ./common
      ];
    };
}
