local status, luasnip_loader = pcall(require, 'luasnip.loaders.from_lua')

if (not status) then return end
;

luasnip_loader.load({
	paths = '~/.config/nvim/LuaSnip/'
})
