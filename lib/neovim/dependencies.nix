{pkgs}:
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
  nodePackages."pyright"
  nodePackages."typescript"
  nodePackages."yaml-language-server"
  haskell-language-server
  lua-language-server
  rust-analyzer
  ltex-ls
  marksman
  texlab
  clang-tools
  nil

  # Formatter
  alejandra
  rustfmt
  stylua
  prettierd
  perl538Packages.LatexIndent
]
