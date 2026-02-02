local M = {}

function M.OpenClearTerminal(direction)
	if direction == "horizontal" then
		vim.cmd("belowright 13split | terminal")
	elseif direction == "vertical" then
		vim.cmd("vsplit | terminal")
	end

	vim.api.nvim_feedkeys("clear\n", "n", false)
	vim.cmd("startinsert")
end

-- ========== ADD THIS SECTION ==========
-- Terminal autocmds to always start in insert mode
local function setup_terminal_autocmds()
	-- When a terminal buffer is created
	vim.api.nvim_create_autocmd("TermOpen", {
		desc = "Start terminal in insert mode",
		pattern = "*",
		callback = function()
			vim.cmd("startinsert")
			-- Optional: Disable line numbers and sign column in terminals
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			vim.opt_local.signcolumn = "no"
		end,
	})

	-- When entering any terminal buffer (refocusing)
	vim.api.nvim_create_autocmd("BufEnter", {
		desc = "Switch to insert mode when entering terminal",
		pattern = "term://*",
		callback = function()
			if vim.bo.buftype == "terminal" then
				vim.cmd("startinsert")
			end
		end,
	})

	-- When leaving terminal buffer
	vim.api.nvim_create_autocmd("BufLeave", {
		desc = "Switch to normal mode when leaving terminal",
		pattern = "term://*",
		callback = function()
			if vim.bo.buftype == "terminal" then
				vim.cmd("stopinsert")
			end
		end,
	})
end

-- Ensure ESC works properly in terminal mode
local function setup_terminal_keymaps()
	-- ESC to exit terminal insert mode
	vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal insert mode" })

	-- Optional: ESC to also close terminal if you want
	-- vim.keymap.set('t', '<Esc>', '<C-\\><C-n>:close<CR>', { noremap = true })
end

-- Initialize terminal settings
function M.setup()
	setup_terminal_autocmds()
	setup_terminal_keymaps()
end

-- Call setup automatically when this module is loaded
M.setup()
-- ========== END ADDED SECTION ==========

return M
