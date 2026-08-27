{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      # url = "github:nix-community/nixvim/nixos-unstable";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    antsdr-uhd = {
      url = "git+https://git-in.dfki.de/lekl02/antsdr_uhd_flake.git";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  inputs.self.submodules = true;
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixvim,
      lanzaboote,
      antsdr-uhd,
      ...
    }:
    {
      nixosConfigurations = {
        dumba-home = inputs.nixpkgs.lib.nixosSystem {
          # stdenv.hostPlatform.system = "x86_64-linux";
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
          # specialArgs = {
          #   antsdr-uhd = inputs.antsdr-uhd;
          # };
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
        # dumba-laptop = inputs.nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = {
        #     antsdr-uhd = antsdr-uhd;
        #   };
        #   modules = [
        #     nixvim.nixosModules.nixvim
        #     lanzaboote.nixosModules.lanzaboote
        #     ./systems/laptop.nix
        #   ];
        # };
        dumba-laptop = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            antsdr-uhd = antsdr-uhd;
          };
          modules = [
            nixvim.nixosModules.nixvim
            lanzaboote.nixosModules.lanzaboote
            ./systems/p1.nix
          ];
        };
      };
    };
}
