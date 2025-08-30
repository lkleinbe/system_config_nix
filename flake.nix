{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # url = "github:nix-community/nixvim/nixos-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, nixvim, lanzaboote, ... }: {
    nixosConfigurations = {
      dumba-home = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixvim.nixosModules.nixvim
          lanzaboote.nixosModules.lanzaboote
          ./base.nix
          ./systems/home.nix
        ];
      };
      dumba-nuc1 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixvim.nixosModules.nixvim
          lanzaboote.nixosModules.lanzaboote
          ./base.nix
          ./systems/nuc1.nix
        ];
      };
      dumba-nuc2 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixvim.nixosModules.nixvim
          lanzaboote.nixosModules.lanzaboote
          ./base.nix
          ./systems/nuc2.nix
        ];
      };
      dumba-nuc3 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixvim.nixosModules.nixvim
          lanzaboote.nixosModules.lanzaboote
          ./base.nix
          ./systems/nuc3.nix
        ];
      };
    };
  };
}
