local status, tree = pcall(require, 'nvim-tree')

if (not status) then return end

tree.setup({
	sort_by = 'case_sensitive',
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
})
