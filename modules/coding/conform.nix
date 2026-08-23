{
  autoCmd = [
    {
      event = ["BufWritePre"];
      callback.__raw = ''
        function(args)
          require("conform").format({ bufnr = args.buf })
        end
      '';
    }
  ];

  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        nix = ["alejandra"];
      };
    };
  };
}
