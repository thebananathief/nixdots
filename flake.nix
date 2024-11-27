{
  description = "TheBananaThief NixOS Infrastructure";

  # This only configures the flake, not the system
  # nixConfig = {
  #   experimental-features = [ "nix-command" "flakes" ];
  #   trusted-users = [ "root" "@wheel" ];
  #   auto-optimise-store = true;
  #   builders-use-substitutes = true;
  #   trusted-substituters = [
  #     "https://cache.nixos.org/?priority=5"
  #     "https://nix-community.cachix.org?priority=10"
  #     "https://cosmic.cachix.org"
  #   ];
  #   extra-trusted-public-keys = [
  #     "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #     "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
  #   ];
  # };

  # Other nix code I want to import or "input" into my flake
  inputs = {
    # This lets us use all the libs and pkgs in nixpkgs itself - flakes don't use Nix's concept of channels for getting pkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # nix-colors.url = "github:misterio77/nix-colors";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    # nixpkgs.follows = "nixos-cosmic/nixpkgs";

    dotfiles.url = "git+ssh://git@github.com/thebananathief/dotfiles.git";
    dotfiles.flake = false;
  };

  # outputs = inputs: with inputs; let
  outputs = inputs @ { self, nixpkgs, home-manager, sops-nix, ... }: 
  let
    username = "cameron";
    useremail = "cameron.salomone@gmail.com";
    globalFonts = import ./modules/globalFonts.nix;

    system = "x86_64-linux";
    specialArgs = {
      inherit username useremail globalFonts;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # config.permittedInsecurePackages = [ 
        # ];
      };
    # // inputs basically means "merge this left side attrset with the right side (inputs)"
    # This line enables you to import the inputs (flakes/modules from github) into modules, aka: ( nixos-cosmic, sops-nix, ... ): {}
    } // inputs;

    # Function to make NixOS systems with common modules & home manager configs
    nixosSystem = {
      system ? "x86_64-linux",
      specialArgs,
      nixos-modules,
      home-module,
    }: nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = nixos-modules ++ [
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users."${username}" = home-module;
        }
        ./modules/common
      ];
    };

    # nixosSystem = {
    #   system ? "x86_64-linux",
    #   args ? {},
    #   argDefaults,
    #   nixos-modules,
    #   home-module
    # }: let
    #   specialArgs = argDefaults // args;
    # in nixpkgs.lib.nixosSystem {
    #   inherit system specialArgs;
    #   # pkgs = nixpkgsCustom system;
    #   modules = nixos-modules ++ [
    #     ../modules/common
    #     home-manager.nixosModules.home-manager {
    #       home-manager.useGlobalPkgs = true;
    #       home-manager.useUserPackages = true;
    #       home-manager.backupFileExtension = "hm-backup";
    #       home-manager.extraSpecialArgs = specialArgs;
    #       home-manager.users."${username}" = home-module;
    #     }
    #   ];
    # };
  in {
    nixosConfigurations = let
      # specialArgs = { inherit argDefaults; };
      base_args = { inherit specialArgs; };
    in {
      talos = nixosSystem ({
        nixos-modules = [ ./hosts/talos ];
        home-module = import ./home/server;
      } // base_args);

      gargantuan = nixosSystem ({
        nixos-modules = [ ./hosts/gargantuan ];
        home-module = import ./home/cameron;
      } // base_args);

      thoth = nixosSystem ({
        nixos-modules = [ ./hosts/thoth ];
        home-module = import ./home/cameron;
      } // base_args);

      icebox = nixosSystem ({
        nixos-modules = [ ./hosts/icebox ];
        home-module = import ./home/server;
      } // base_args);
    };
  };
}
