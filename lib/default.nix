{
  system,
  inputs,
  isNixOSModule ? false,
  ...
}: {
  lib,
  config,
  ...
}: let
  inherit (pkgs) vimUtils;
  inherit (vimUtils) buildVimPlugin;
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  extraPackages = inputs.nixpkgs.legacyPackages.${system}.callPackage ./neovim/dependencies.nix {inherit system inputs;};
  neovim = pkgs.wrapNeovim inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim {
    configure = {
      customRC = ''
        lua << EOF
          require("EntenVim")
        EOF
      '';
      packages.main = let
        EntenVim = buildVimPlugin {
          name = "EntenVim";
          postInstall = ''
          '';
          src = ../nvim;
          nvimSkipModules = [
            "entenvim.plugins.lazy"
            "entenvim.plugins.telescope"
            "entenvim.user.init"
            "entenvim.user.lazy"
            "entenvim.util.init"
            "EntenVim"
            "init"
          ];
        };
        start = [EntenVim];
      in {inherit start;};
      extraMakeWrapperArgs = ''--suffix PATH : "${lib.makeBinPath extraPackages}"'';
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
in {
  options.programs.entenvim = {
    enable = lib.mkEnableOption "Enable EntenVim a custom neovim distribution";
    package = lib.mkOption {
      type = lib.types.package;
    };
    dependencies = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };
  };

  config = lib.mkIf config.programs.entenvim.enable (
    lib.mkMerge [
      {
        programs.entenvim.package = neovim;
        programs.entenvim.dependencies = extraPackages;
      }
      (
        if isNixOSModule
        then {environment.systemPackages = [config.programs.entenvim.package] ++ config.programs.entenvim.dependencies;}
        else {home.packages = [config.programs.entenvim.package] ++ config.programs.entenvim.dependencies;}
      )
    ]
  );
}
