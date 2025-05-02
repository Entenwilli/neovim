{
  inputs,
  system,
}: let
  inherit (pkgs) nodePackages;
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
  with pkgs; [
    # Telescope
    fd
    fzf
    ripgrep
    # Installation utilities (for mason)
    unzip
    git
    curl
    gnutar
    gzip
    patchelf

    # Language servers
    nodePackages."bash-language-server"
    nodePackages."diagnostic-languageserver"
    nodePackages."dockerfile-language-server-nodejs"
    pyright
    nodePackages."typescript"
    nodePackages."yaml-language-server"
    vscode-langservers-extracted
    haskell-language-server
    lua-language-server
    rust-analyzer
    ltex-ls
    marksman
    texlab
    clang-tools
    nil
    nixd
    vue-language-server
    tailwindcss-language-server

    # Formatter
    alejandra
    rustfmt
    stylua
    prettierd
    perl538Packages.LatexIndent
  ]
