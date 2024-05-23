{
  description = "Personal neovim configuration for NixOS";

  inputs = {
    # NixOS packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake utils
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      flake = {
        lib = import ./lib {inherit inputs;};
        homeManagerModules.default = import ./lib/homemanager.nix self;
        overlays.default = final: prev: {
          neovim = self.packages.${prev.system}.neovim;
        };
      };
      perSystem = {
        config,
        self',
        inputs,
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs) alejandra;
      in {
        packages = rec {
          neovim = self.lib.mkNeovim {inherit system;};
          #neovim = nixpkgs.legacyPackages.${system}.callPackage ./lib/neovim {
          #  neovim = pkgs.neovim;
          #};
          default = neovim;
          config = neovim.passthru.config;
        };
        formatter = alejandra;
        apps = {
          nvim = {
            program = "${self.packages.${system}.packages.neovim}/bin/nvim";
            type = "app";
          };
        };
      };
    };
}
