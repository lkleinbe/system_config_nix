{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
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
          ./systems/home.nix
        ];
      };
      gameserver = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixvim.nixosModules.nixvim
          lanzaboote.nixosModules.lanzaboote
          ./systems/gameserver.nix
        ];
      };
      dumba-nuc1 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixvim.nixosModules.nixvim
          lanzaboote.nixosModules.lanzaboote
          ./systems/nuc1.nix
        ];
      };
      dumba-nuc2 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixvim.nixosModules.nixvim
          lanzaboote.nixosModules.lanzaboote
          ./systems/nuc2.nix
        ];
      };
      dumba-nuc3 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixvim.nixosModules.nixvim
          lanzaboote.nixosModules.lanzaboote
          ./systems/nuc3.nix
        ];
      };
      kulli-home = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixvim.nixosModules.nixvim
          lanzaboote.nixosModules.lanzaboote
          ./systems/kulli.nix
        ];
      };
      dumba-laptop = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixvim.nixosModules.nixvim
          lanzaboote.nixosModules.lanzaboote
          ./systems/laptop.nix
        ];
      };
    };
  };
}
