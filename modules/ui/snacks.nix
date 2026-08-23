{lib, ...}: {
  plugins.snacks = {
    enable = true;
    settings = {
      explorer = {
        enabled = true;
        replace_netrw = true;
        trash = true;
      };
      indent.enabled = true;
      input.enabled = true;
      notifier.enabled = true;
      scope.enabled = true;
      scroll.enabled = true;
      statuscolumn.enabled = false;
      words.enabled = true;
      dashboard = {
        preset.header = ''
          ███████╗███╗   ██╗████████╗███████╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
          ██╔════╝████╗  ██║╚══██╔══╝██╔════╝████╗  ██║██║   ██║██║████╗ ████║
          █████╗  ██╔██╗ ██║   ██║   █████╗  ██╔██╗ ██║██║   ██║██║██╔████╔██║
          ██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
          ███████╗██║ ╚████║   ██║   ███████╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
          ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
        '';
        sections = [
          {section = "header";}
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
        ];
      };
    };
  };

  keymaps = [
    {
      key = "<leader>e";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.explorer()
        end
      '';
    }
    {
      key = "<leader>gg";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.terminal({"lazygit"})
        end
      '';
    }
    {
      key = "<leader>tf";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.terminal({"fish"})
        end
      '';
    }
  ];
}
