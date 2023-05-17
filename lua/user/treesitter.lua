local status, configs = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

local languages = {
    'c',
    'rust',
    'vim',
    'html',
    'astro',
    'css',
    'fish',
    'gitcommit',
    'html',
    'latex',
    'lua',
    'markdown'
}

configs.setup {
  ensure_installed = languages,
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = { 'yaml' }
  }
}
