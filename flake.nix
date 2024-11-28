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

    dotfiles.url = "git+ssh://git@talos:2222/cameron/dotfiles.git?ref=main";
    dotfiles.flake = false;
  };

  outputs = inputs: with inputs;
  let
    username = "cameron";
    useremail = "cameron.salomone@gmail.com";
    globalFonts = import ./modules/globalFonts.nix;

    # The `// inputs` bit means "merge this left side attrset with the right side (inputs)"
    # It lets you use the flake inputs in the modules (sops-nix, nixos-hardware)
    defaultArgs = { 
      inherit username useremail globalFonts;
    } // inputs;

    nixpkgsCustom = system: (import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      # config.permittedInsecurePackages = [ 
      # ];
    });

    # Function to make NixOS systems with common modules & home manager configs
    mkNixosSystem = {
      system ? "x86_64-linux",
      nixos-modules,
    }: let
      specialArgs = defaultArgs;
    in nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      pkgs = nixpkgsCustom system;
      modules = nixos-modules ++ [
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = specialArgs;
        }
        ./modules/common
        sops-nix.nixosModules.sops
      ];
    };
  in {
    nixosConfigurations = {
      talos = mkNixosSystem {
        nixos-modules = [ ./hosts/talos ];
      };
      gargantuan = mkNixosSystem {
        nixos-modules = [ ./hosts/gargantuan ];
      };
      thoth = mkNixosSystem {
        nixos-modules = [ ./hosts/thoth ];
      };
      thoth-wsl = mkNixosSystem {
        nixos-modules = [ ./hosts/thoth/wsl-default.nix ];
      };
      icebox = mkNixosSystem {
        nixos-modules = [ ./hosts/icebox ];
      };
    };
  };
}
