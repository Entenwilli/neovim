local luasnip = require("luasnip")
local text = luasnip.text_node
local insert = luasnip.insert_node
local func = luasnip.function_node
local dynamic = luasnip.dynamic_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	require("luasnip").snippet(
		{ trig = "hmmod" },
		fmt(
			[[ 
          {
            self,
            inputs,
            lib,
            ...
          }: {
            flake.homeManagerModules.<>= {
              pkgs,
              config,
              ...
            }: {
              imports = [
                <>
              ];

              options = {
                <>.enable = lib.mkEnableOption "<>";
              };

              config = lib.mkIf config.<>.enable {
                <>
              };
            };
          }
      ]],
			{ insert(1), insert(2), rep(1), insert(3), rep(1), insert(4) },
			{ delimiters = "<>" }
		)
	),
}
