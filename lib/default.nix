{
  self,
  system,
  isNixOSModule ? false,
}: {
  lib,
  pkgs,
  config,
  ...
}: let
  pkgs = import ./pkgs.nix;
in {
  options.programs.entenvim = {
    enable = lib.mkEnableOption "Enable EntenVim a custom neovim distribution";
  };

  config = lib.mkIf config.programs.entenvim.enable (
    if isNixOSModule
    then {environment.systemPackages = pkgs.mkNeovim {inherit system;};}
    else {home.packages = pkgs.mkNeovim {inherit system;};}
  );
}
