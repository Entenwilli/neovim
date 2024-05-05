{
  description = "Personal neovim configuration for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        # Local build support is included here
        lib = import ./lib {inherit inputs;};
      };

      systems = ["x86_64-linux"];

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
        apps = {
          nvim = {
            program = "${config.packages.neovim}/bin/nvim";
            type = "app";
          };
        };

        formatter = alejandra;

        packages = {
          default = self.lib.mkVimPlugin {inherit system;};
          neovim = self.lib.mkNeovim {inherit system;};
        };
      };
    };
}
