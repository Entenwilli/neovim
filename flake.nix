{
  description = "Personal neovim configuration for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    lib = import ./lib {inherit inputs;};
  in {
    overlays.default = final: prev: {
      neovim = self.packages.${prev.system}.neovim;
    };
    packages = forAllSystems (system: rec {
      # neovim = lib.mkNeovim {inherit system;};
      neovim = nixpkgs.legacyPackages.${system}.callPackage ./lib/neovim {
        neovim = inputs.neovim.packages.${nixpkgs.legacyPackages.${system}.system}.neovim;
      };
      default = neovim;
      config = neovim.passthru.config;
    });
    apps = forAllSystems (pkgs: {
      nvim = {
        program = "${self.packages.${pkgs.system}.packages.neovim}/bin/nvim";
        type = "app";
      };
    });
    homeManagerModules.default = import ./lib/homemanager.nix self;
  };
}
