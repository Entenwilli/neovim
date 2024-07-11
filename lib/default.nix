{inputs}: let
  inherit (inputs.nixpkgs) legacyPackages;
in rec {
  mkVimPlugin = {system}: let
    inherit (pkgs) vimUtils;
    inherit (vimUtils) buildVimPlugin;
    pkgs = legacyPackages.${system};
  in
    buildVimPlugin {
      name = "EntenVim";
      postInstall = ''
      '';
      src = ../nvim;
    };

  mkNeovimPlugins = {system}: let
    EntenVim = mkVimPlugin {inherit system;};
  in [
    EntenVim
  ];

  mkExtraPackages = {system}: let
    inherit (pkgs) nodePackages python3Packages;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in [
    # Installation utilities (for mason)
    pkgs.unzip
    pkgs.git
    pkgs.curl
    pkgs.gnutar
    pkgs.gzip
    pkgs.patchelf

    # Language servers
    nodePackages."bash-language-server"
    nodePackages."diagnostic-languageserver"
    nodePackages."dockerfile-language-server-nodejs"
    pkgs.pyright
    nodePackages."typescript"
    nodePackages."yaml-language-server"
    pkgs.vscode-langservers-extracted
    pkgs.haskell-language-server
    pkgs.lua-language-server
    pkgs.rust-analyzer
    pkgs.ltex-ls
    pkgs.marksman
    pkgs.texlab
    pkgs.clang-tools
    pkgs.nil

    # Formatter
    pkgs.alejandra
    pkgs.rustfmt
    pkgs.stylua
    pkgs.prettierd
    pkgs.perl538Packages.LatexIndent
  ];

  mkExtraConfig = ''
    lua << EOF
      require('EntenVim')
    EOF
  '';

  mkNeovim = {system}: let
    inherit (pkgs) lib neovim;
    extraPackages = mkExtraPackages {inherit system;};
    pkgs = legacyPackages.${system};
    start = mkNeovimPlugins {inherit system;};
  in
    neovim.override {
      configure = {
        customRC = mkExtraConfig;
        packages.main = {inherit start;};
      };
      extraMakeWrapperArgs = ''--suffix PATH : "${lib.makeBinPath extraPackages}"'';
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };

  mkHomeManager = {system}: let
    extraConfig = mkExtraConfig;
    extraPackages = mkExtraPackages {inherit system;};
    plugins = mkNeovimPlugins {inherit system;};
    pkgs = legacyPackages.${system};
  in {
    inherit extraConfig extraPackages plugins;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    enable = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    package = pkgs.neovim-unwrapped;
  };
}
