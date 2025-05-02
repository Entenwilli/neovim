{
  description = "Personal neovim configuration for NixOS";

  inputs = {
    # NixOS packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Neovim Nighly Overlay
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    inherit (nixpkgs) lib;
    withSystem = f:
      lib.fold lib.recursiveUpdate {} (
        map f [
          "x86_64-linux"
        ]
      );
  in
    withSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeManagerModules = {
        neovim = import "${self}/lib/default.nix" {
          inherit system inputs;
          isNixOSModule = false;
        };
        default = self.homeManagerModules.neovim;
      };

      nixosModules = {
        neovim = import "${self}/lib/default.nix" {
          inherit system inputs;
          isNixOSModule = true;
        };
        default = self.nixosModules.neovim;
      };

      formatter.${system} = pkgs.alejandra;
    });
}
