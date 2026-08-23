{...}: {
  plugins.conform-nvim = {
    enable = true;
    autoInstall = {
      enable = true;
      enableWarnings = true;
    };

    settings = {
      format_on_save = {
        timeout_ms = 200;
        lsp_format = "fallback";
      };
      formatters_by_ft = {
        nix = ["alejandra"];
      };
    };
  };
}
