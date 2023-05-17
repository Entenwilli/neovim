local cmp_status, cmp = pcall(require, 'cmp')
if (not cmp_status) then return end

local luasnip_status, luasnip = pcall(require, 'luasnip')
if (not luasnip_status) then return end

local lspkind_status, lspkind = pcall(require, 'lspkind')
if (not lspkind_status) then return end

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-1),
    ['<C-f>'] = cmp.mapping.scroll_docs(1),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.disable,
    ['<C-e>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close()
    },
    ['<CR>'] = cmp.mapping.confirm {
      select = true
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
  formatting = {
    format = lspkind.cmp_format({
      wirth_text = false,
      maxwidth = 50
    })
  },
  confirm_opts = {
    behaviour = cmp.ConfirmBehavior.Replace,
    select = false,
  },
}
