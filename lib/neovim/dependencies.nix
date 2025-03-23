{
  inputs,
  system,
}: let
  inherit (pkgs) nodePackages;
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  new-tailwindcss-language-server =
    pkgs.tailwindcss-language-server.overrideAttrs
    (old: {
      src = pkgs.fetchFromGitHub {
        owner = "tailwindlabs";
        repo = "tailwindcss-intellisense";
        rev = "v0.14.11";
        hash = "sha256-LMQ+HA74Y0n65JMO9LqCHbDVRiu4dIUvQofFTA03pWU=";
      };
    });
in
  with pkgs;
    [
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

      # Formatter
      alejandra
      rustfmt
      stylua
      prettierd
      perl538Packages.LatexIndent
    ]
    ++ [new-tailwindcss-language-server]
