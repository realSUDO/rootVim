return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.clang_format.with({
					extra_args = { "--style=file" },
				}),
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
			},
			-- 👇 Increase timeout to 5000ms (5 sec)
			default_timeout = 5000,
			on_attach = function(client, bufnr)
				-- Optional: custom per-buffer format command
				vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gf", "", {
					callback = function()
						vim.lsp.buf.format({ timeout_ms = 5000 })
					end,
					noremap = true,
					silent = true,
				})
			end,
		})
	end,
}

