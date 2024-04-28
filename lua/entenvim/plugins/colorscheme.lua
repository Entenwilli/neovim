return {
  {
    'folke/tokyonight.nvim',
    opts = {
      style = 'night'
    },
    lazy = true,
    init = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  }
}
