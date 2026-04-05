{
  inputs,
  system,
}: let
  inherit (pkgs);
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
    libgcc

    # Language servers
    bash-language-server
    diagnostic-languageserver
    dockerfile-language-server
    python313Packages.python-lsp-server
    typescript-language-server
    yaml-language-server
    vscode-langservers-extracted
    haskell-language-server
    lua-language-server
    rust-analyzer
    ltex-ls
    glsl_analyzer
    kdePackages.qtdeclarative
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
    perl5Packages.LatexIndent
  ]
