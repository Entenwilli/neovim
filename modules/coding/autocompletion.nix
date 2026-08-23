{
  plugins.blink-cmp = {
    enable = true;
    setupLspCapabilities = true;
    settings = {
      completion = {
        accept = {
          create_undo_point = false;
          auto_brackets.enabled = true;
        };
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 100;
          window.border = "rounded";
        };
        ghost_text.enabled = true;
        list.selection = {
          auto_insert = false;
          preselect = true;
        };
        trigger = {
          show_in_snippet = true;
          show_on_keyword = true;
          show_on_trigger_character = true;
          show_on_accept_on_trigger_character = true;
          show_on_insert_on_trigger_character = true;
        };
      };

      signature = {
        enabled = true;
        window.border = "rounded";
      };

      snippets.preset = "luasnip";

      sources = {
        default = [
          "buffer"
          "lsp"
          "path"
          "snippets"
        ];
        providers = {
          lsp.score_offset = 4;
        };
      };
      keymap = {
        "<Tab>" = [
          "snippet_forward"
          "fallback"
        ];
        "<S-Tab>" = [
          "snippet_backward"
          "fallback"
        ];
        "<C-space>" = [
          "show"
          "show_documentation"
          "hide_documentation"
        ];
        "<CR>" = [
          "accept"
          "fallback"
        ];
      };
    };
  };
}
