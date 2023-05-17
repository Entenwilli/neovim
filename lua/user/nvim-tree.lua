local status, tree = pcall(require, 'nvim-tree')
if (not status) then return end

tree.setup({
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
	sort_by = 'case_sensitive',
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
})
