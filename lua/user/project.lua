local status, project = pcall(require, 'project_nvim')
if (not status) then return end

project.setup({
  detection_methods = { 'pattern' },
  patterns = { '.git', 'package.json', 'Makefile' }
})

local telescope_status, telescope = pcall(require, 'telescope')
if (not telescope_status) then return end

telescope.load_extension('projects')
