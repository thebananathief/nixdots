{
  description = "NixOS configuration";

  # This only configures the flake, not the system
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];

    substituters = [
      "https://cache.nixos.org/?priority=5"
      "https://nix-community.cachix.org?priority=10"
      "https://anyrun.cachix.org"
      # "https://pre-commit-hooks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      # "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # Something like this if you want to move secrets to a completely private repo
    # mysecrets = {
    #   url = "git+ssh://git@github.com/thebananathief/nix-secrets.git?shallow=1";
    #   flake = false;
    # };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, sops-nix, ... }:
    let
      username = "cameron";
      useremail = "cameron.salomone@gmail.com";

      globalFonts = {
        serif = "Noto Serif";
        monospace = "JetBrainsMono Nerd Font";
        # was M+2 (for waybar)
        prettyNerd = "M+2 Nerd Font";
        sansSerif = "Noto Sans";
      };

      pkgs = import <nixpkgs> {};
      system = "x86_64-linux";
      nixosSystem = import ./lib/nixosSystem.nix;
      specialArgs = {
        inherit username useremail globalFonts;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.permittedInsecurePackages = [ "electron-25.9.0" ];
        };
      # The // inputs part here is us feeding in the inputs from this flake into the special args, the special args go into the different modules to be used further
      } // inputs;
    in {
      nixosConfigurations = let
        # This feeds in everything we need at ./lib/nixosSystem.nix
        base_args = { inherit home-manager nixpkgs system specialArgs; };
      in {
        gargantuan = nixosSystem ({
          nixos-modules = [ ./hosts/gargantuan ];
          home-module = import ./home/cameron;
        } // base_args);

        thoth = nixosSystem ({
          nixos-modules = [ ./hosts/thoth ];
          home-module = import ./home/cameron;
        } // base_args);

        talos = nixosSystem ({
          nixos-modules = [ ./hosts/talos ];
          home-module = import ./home/server;
        } // base_args);
      };
    };
}
