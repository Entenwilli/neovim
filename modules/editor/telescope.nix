{
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
    };
    keymaps = {
      "<leader>/" = {
        action = "live_grep";
        options = {
          desc = "Grep (Root Dir)";
        };
      };
      "<leader><space>" = {
        action = "find_files";
        options = {
          desc = "Find Files (Root Dir)";
        };
      };
      "<leader>ff" = {
        action = "find_files";
        options = {
          desc = "Find Files (Root Dir)";
        };
      };
    };
  };
}
