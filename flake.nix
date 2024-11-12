{
  description = "Personal neovim configuration for NixOS";

  inputs = {
    # NixOS packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
          inherit self system;
          isNixOSModule = false;
        };
        default = self.homeManagerModules.neovim;
      };

      nixosModules = {
        neovim = import "${self}/lib/default.nix" {
          inherit self system;
          isNixOSModule = true;
        };
        default = self.nixosModules.neovim;
      };

      formatter.${system} = pkgs.alejandra;
    });
}
