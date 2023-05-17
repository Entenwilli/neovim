local status, theme = pcall(require, 'tokyonight')
if (not status) then return end

theme.setup({
  style = 'night'
})

vim.cmd [[colorscheme tokyonight-night]]
