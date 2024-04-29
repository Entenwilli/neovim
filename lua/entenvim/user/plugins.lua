local status, lazy = pcall(require, "lazy")
if not status then
	return
end

lazy.setup("entenvim.plugins", {
	performance = {
		reset_packpath = false,
	},
})
