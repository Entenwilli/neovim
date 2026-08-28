{lib, ...}: {
  plugins.neoconf.enable = true;

  diagnostic.settings = {
    signs.text = {
      "__rawKey__vim.diagnostic.severity.ERROR" = " ";
      "__rawKey__vim.diagnostic.severity.WARN" = " ";
      "__rawKey__vim.diagnostic.severity.HINT" = "󰌵";
      "__rawKey__vim.diagnostic.severity.INFO" = " ";
    };
    virtual_lines = true;
    virtual_text = true;
  };

  lsp = {
    inlayHints.enable = true;
    keymaps = [
      {
        key = "gd";
        lspBufAction = "definition";
      }
      {
        key = "gr";
        lspBufAction = "references";
      }
      {
        key = "gI";
        lspBufAction = "implementation";
      }
      {
        key = "gy";
        lspBufAction = "type_definition";
      }
      {
        key = "gD";
        lspBufAction = "declaration";
      }
      {
        key = "K";
        lspBufAction = "hover";
      }
      {
        key = "gK";
        lspBufAction = "signature_help";
      }
    ];
    servers = {
      "*" = {
        config.capibilities.workspace.fileOperations = {
          didRename = true;
          willRename = true;
        };
      };
    };
  };
  plugins.lsp = {
    enable = true;
    servers = {
      clangd.enable = true;
      volar.enable = true;
      tailwindcss.enable = true;
      glsl_analyzer.enable = true;
      ts_ls.enable = true;
      ltex = {
        enable = true;
        settings = {
          ltex = {
            language = "en-US";

            additionalrules = {
              enablepickyrules = true;
              mothertongue = "de";
            };
            completionenabled = true;
          };
        };
      };
      rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };
      pylsp.enable = true;
      qmlls.enable = true;
      nixd = {
        enable = true;
        settings = {
          nixd = {
            options = {
              nixpkgs = {
                expr = "import (builtins.getFlake (builtins.toString /home/felix/nixos)).inputs.nixpkgs { }";
              };
              formatting = {
                command.__raw = "{ \"alejandra\" }";
              };
              options = {
                nixos = {
                  expr = "(builtins.getFlake (builtins.toString /home/felix/nixos)).nixosConfigurations.nixos-desktop.options";
                };
                home_manager = {
                  expr = "(builtins.getFlake (builtins.toString /home/felix/nixos)).nixosConfigurations.nixos-desktop.options.home-manager.users.type.getSubOptions []";
                };
              };
            };
          };
        };
      };
    };
  };
}
