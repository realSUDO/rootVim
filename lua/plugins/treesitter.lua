return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			-- Auto-install parsers
			auto_install = true,

			-- Highlight configuration with safety checks
			highlight = {
				enable = true,
				-- Prevent errors on large files
				disable = function(lang, buf)
					local max_filesize = 500 * 1024 -- 500KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						vim.notify("Disabled TS highlight for large file", vim.log.levels.WARN)
						return true
					end
				end,
				-- Additional protection against range errors
				additional_vim_regex_highlighting = false,
			},

			-- Indentation
			indent = {
				enable = true,
				disable = { "python", "yaml" }, -- Languages where TS indent often breaks
			},

			-- Performance optimizations
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},

			-- Ensure parsers stay updated
			ensure_installed = {
				"lua",
				"python",
				"javascript",
				"typescript",
				"bash",
				"json",
				"yaml",
			},
		})

		-- Workaround for highlight range errors
		vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd" }, {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
