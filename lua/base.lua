vim.cmd('autocmd!')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.wo.number = true
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.backup = false
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.shell = 'fish'
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.ai = true            -- Auto indent
vim.opt.si = true            -- Smart indent
vim.opt.wrap = false         -- No wrapping lines
vim.opt.backspace = 'start,eol,indent'
vim.opt.path:append { '**' } -- Enable subdirectory search

-- Ignore folders in search
vim.opt.wildignore:append { '*/node_modules/*' }
