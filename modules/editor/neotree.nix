{
  plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      enable_git_status = true;
      enable_diagnostics = true;
      sources = [
        "filesystem"
        "buffers"
        "git_status"
      ];
      filesystem = {
        filtered_items = {
          visible = false;
          hide_dotfiles = true;
          hide_gitignored = true;
        };
      };
      source_selector = {
        winbar = true;
        statusline = true;
      };
      default_component_configs = {
        indent = {
          indent_size = 2;
          padding = 1;
          with_markers = true;
          indent_marker = "│";
          last_indent_marker = "└";
          highlight = "NeoTreeIndentMarker";
          with_expanders = true;
          expander_collapsed = "";
          expander_expanded = "";
          expander_highlight = "NeoTreeExpander";
        };
        modified = {
          symbol = "[+]";
          highlight = "NeoTreeModified";
        };
        name = {
          trailing_slash = false;
          use_git_status_colors = true;
          highlight = "NeoTreeFileName";
        };
        git_status = {
          symbols = {
            added = "✚";
            modified = "";
            untracked = "";
            ignored = "";
            unstaged = "U";
            staged = "";
            conflict = "";
          };
        };
      };
    };
  };
  keymaps = [
    {
      action = "<cmd>Neotree toggle<CR>";
      key = "<leader>e";
      mode = "n";
    }
  ];
}
