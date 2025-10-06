-- lazy.nvim
return {
	{
		"chrisgrieser/nvim-origami",
		event = "VeryLazy",
		opts = {},

		init = function()
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99

			vim.opt.fillchars = {
				foldopen = "",
				foldclose = "",
				fold = " ",
				foldsep = " ",
				diff = "╱",
			}

			vim.opt.foldcolumn = "1" -- '0' is not bad
		end,
	},
	{
		"luukvbaal/statuscol.nvim",
		opts = function()
			local builtin = require("statuscol.builtin")
			vim.opt.foldcolumn = "1"
			vim.opt.fillchars = {
				foldopen = "",
				foldclose = "",
				fold = " ",
				foldsep = " ",
				diff = "╱",
			}
			return {
				setopt = true,
				segments = {
					{
						text = { builtin.lnumfunc, " " },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
					{
						text = { builtin.foldfunc, " " },
						condition = { true, builtin.non_empty },
						click = "v:lua.ScFa",
					},
				},
			}
		end,
	},
}

