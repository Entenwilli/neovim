local status, luasnip = pcall(require, "luasnip")

if not status then
	return
end

local snippet = luasnip.snippet
local i = luasnip.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
	snippet(
		{ trig = "kit", dscr = "An entry for the kit working time datasheet" },
		fmta(
			[[
        {
          "action": "<>",
          "day": <>,
          "start": "<>",
          "end": "<>"
        }
      ]],
			{ i(1), i(2), i(3), i(4) }
		)
	),
}
