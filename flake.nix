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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # mysecrets = {
    #   url = "git+ssh://git@github.com/thebananathief/nix-secrets.git?shallow=1";
    #   flake = false;
    # };
  };

  outputs = inputs @ { self, nixpkgs, nixos-hardware, home-manager, sops-nix, ... }:
    let
      # TODO: These should really be obfuscated
      username = "cameron";
      useremail = "cameron.salomone@gmail.com";
      globalFonts = {
        serif = "Gelasio";
        monospace = "FiraCode Nerd Font Regular";
        prettyNerd = "M+1 Nerd Font";
        sansSerif = "Lexend";
      };

      nixosSystem = import ./lib/nixosSystem.nix;
      
      system = "x86_64-linux";

      x64_specialArgs = {
        inherit username useremail globalFonts;
        # This part allows us to install non-free software from nixpkgs, you can also put this further down and ref with nixpkgs.config.allowUnfree
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      # The // inputs part here is us feeding in the inputs from this flake into the special args, the special args go into the different modules to be used further
      } // inputs;
    in {
      nixosConfigurations = let
        base_args = {
          inherit home-manager;
          system = "x86_64-linux";
          specialArgs = x64_specialArgs;
          nixpkgs = nixpkgs;
        };
      in {
        gargantuan = nixosSystem ({
          nixos-modules = [
            nixos-hardware.nixosModules.framework
            ./hosts/gargantuan/gargantuan.nix
          ];
          home-module = import ./home/cameron;
        } // base_args);

        # Testing environment VM
        zelos = nixosSystem ({
          nixos-modules = [ ./hosts/zelos/zelos.nix ];
          home-module = import ./home/server;
        } // base_args);

        talos = nixosSystem ({
          nixos-modules = [ ./hosts/talos/talos.nix ];
          home-module = import ./home/server;
        } // base_args);
      };
    };
}
