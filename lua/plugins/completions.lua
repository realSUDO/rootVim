return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"github/copilot.vim",
	},
	{
		"SirVer/ultisnips",
		dependencies = {
			"quangnguyen30192/cmp-nvim-ultisnips",
		},
		config = function()
			local packaged_py = "/usr/share/rootvim/.globalPython/bin/python3"
			local global_py = os.getenv("HOME") .. "/.globalPython/bin/python3"

			if vim.fn.filereadable(packaged_py) == 1 then
				vim.g.python3_host_prog = packaged_py
			elseif vim.fn.filereadable(global_py) == 1 then
				vim.g.python3_host_prog = global_py
			elseif vim.fn.executable("python3") == 1 then
				vim.g.python3_host_prog = vim.fn.exepath("python3")
			end
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["UltiSnips#Anon"](args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "ultisnips" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
