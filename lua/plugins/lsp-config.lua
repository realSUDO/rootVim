return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = { "codelldb", "black", "isort" },
		},
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "clangd", "ts_ls", "pyright" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- 🔁 Determine pythonPath for pyright
			local packaged_py = "/usr/share/rootvim/.globalPython/bin/python" 
 			local global_py = os.getenv("HOME") .. "/.globalPython/bin/python"
			local python_path = ""
			if vim.fn.filereadable(packaged_py) == 1 then
				python_path = packaged_py
			elseif vim.fn.filereadable(global_py) == 1 then
				python_path = global_py
			elseif vim.fn.executable("python3") == 1 then
				python_path = vim.fn.exepath("python3")
			else
				vim.notify("[LSP] No valid Python interpreter found for Pyright", vim.log.levels.WARN)
			end

			-- 🧠 LSP setups using vim.lsp.config
			vim.lsp.config.lua_ls = {
				cmd = { "lua-language-server" },
				capabilities = capabilities,
			}
			vim.lsp.config.clangd = {
				cmd = { "clangd" },
				capabilities = capabilities,
			}
			vim.lsp.config.ts_ls = {
				cmd = { "typescript-language-server", "--stdio" },
				capabilities = capabilities,
			}
			vim.lsp.config.bashls = {
				cmd = { "bash-language-server", "start" },
				capabilities = capabilities,
			}
			vim.lsp.config.pyright = {
				cmd = { "pyright-langserver", "--stdio" },
				capabilities = capabilities,
				settings = {
					python = {
						pythonPath = python_path,
					},
				},
			}
			vim.lsp.config.emmet_ls = {
				cmd = {"emmet-language-server", "--stdio"},
				capabilities = capabilities,
			}

			-- Enable LSPs
			vim.lsp.enable({ "lua_ls", "clangd", "ts_ls", "bashls", "pyright","emmet_ls" })

			-- 🗝️ Keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
