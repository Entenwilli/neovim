local status, luasnip = pcall(require, 'luasnip')

if (not status) then return end

local snippet = luasnip.snippet;
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local d = luasnip.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
	snippet({ trig = 'itemize', dscr = 'A LaTeX itemize environment' },
		fmta(
			[[
				\begin{itemize}
					<>
				\end{itemize}
			]],
			{ i(1) }
		)
	),
	snippet({ trig = 'item', dscr = 'A LaTeX item' },
		fmta(
			[[
				\item{<>}
			]],
			{ i(1) }
		)
	),
	snippet({ trig = 'eq', dscr = 'A LaTeX equation' },
		fmta(
			[[
				\begin{equation}
					<>
				\end{equation}
			]],
			{ i(1) }
		)
	),
	snippet({ trig = 'begin', dscr = 'A LaTeX environment' },
		fmta(
			[[
				\begin{<>}
					<>
				\end{<>}
		]],
			{ i(1), i(2), rep(1) }
		)
	),
}
