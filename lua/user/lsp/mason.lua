local mason_status, mason = pcall(require, 'mason')
if (not mason_status) then return end

local mason_lsp_status, mason_lspconfig = pcall(require, 'mason-lspconfig')
if (not mason_lsp_status) then return end

local servers = {
  'lua_ls',
  'html',
  'rust_analyzer',
  'texlab',
  'marksman'
}

local settings = {
  ui = {
    border = 'none',
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

local lspconfig_status, lspconfig = pcall(require, 'lspconfig')
if (not lspconfig_status) then return end

local opts = {}
for _, server in pairs(servers) do
  opts = {
    on_attach = require('user.lsp.handlers').on_attach,
    capabilities = require('user.lsp.handlers').capabilities,
  }
  server = vim.split(server, '@')[1]

  local conf_status, conf = pcall(require, 'user.lsp.settings.' .. server)
  if conf_status then
    opts = vim.tbl_deep_extend('force', conf, opts)
  end

  lspconfig[server].setup(opts)
end
