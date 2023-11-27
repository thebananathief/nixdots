{
  description = "NixOS configuration";

  # This only configures the flake, not the system
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];

    substituters = [
      "https://cache.nixos.org/?priority=5"
      "https://nix-community.cachix.org?priority=10"
      "https://anyrun.cachix.org"
      "https://hyprland.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { nixpkgs, nixos-hardware, home-manager, ... }:
    let
      # TODO: These should really be obfuscated
      username = "cameron";
      userfullName = "Cameron Salomone";
      useremail = "cameron.salomone@gmail.com";

      nixosSystem = import ./lib/nixosSystem.nix;
      
      system = "x86_64-linux";

      x64_specialArgs = {
        inherit username userfullName useremail;
      } // inputs;
      
      # defaultModules = [
      #   # { _module.args = { inherit inputs; }; }
      #   home-manager.nixosModules.home-manager
      #   {
      #     home-manager.useGlobalPkgs = true;
      #     home-manager.useUserPackages = true;
      #     home-manager.users.cameron = import ./home/cameron;
      #   }
      #   ./common
      # ];
      # mkPkgs = import nixpkgs {
      #   config.allowUnfree = true;
      #   inherit system;
      # };
      # mkSystem = extraModules:
      #   nixpkgs.lib.nixosSystem rec {
      #     pkgs = mkPkgs;
      #     system = "x86_64-linux";
      #     modules = defaultModules ++ extraModules;
      #     specialArgs = { inherit inputs; };
      #   };
      # specialArgs =
      # {} // inputs;
    in {
      #lib = { inherit mkSystem; };
      nixosConfigurations = let
        sys_gargantuan = {
          nixos-modules = [
            nixos-hardware.nixosModules.framework
            ./hosts/gargantuan
          ];
          home-module = [ ./home/cameron ];
        };

        sys_talos = {
          nixos-modules = [ ./hosts/talos ];
          home-module = [ ./home/server ];
        };
        
        sys_zelos = {
          nixos-modules = [ ./hosts/zelos ];
        };
        
        base_args = {
          inherit home-manager;
          system = "x86_64-linux";
          specialArgs = x64_specialArgs;
          # nixpkgs = nixpkgs;
        };
      in {
        gargantuan = nixosSystem (sys_gargantuan // base_args);
        talos = nixosSystem (sys_talos // base_args);
        zelos = nixosSystem (sys_zelos // base_args);
      };
    };
}
