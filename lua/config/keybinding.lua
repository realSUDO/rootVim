--define a helper function to set keymapping..
local function map(mode, lhs, rhs, opts)
	--set defualt options
	local options = { noremap = true, silent = true }
	--for additional option .. merge if provided
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	--set keymapping using final option
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
--switching panes
map("n", "<C-j>", "<C-w>j")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-h>", "<C-w>h")

--closing terminal
map("t", "<leader>tt", "exit <CR> ", {})

--compile and run
map("n", "<leader><leader><leader>r", ":w<CR> | :lua CompileAndRun()<CR>")

--open terminal horizontal
map("n", "<leader>tt", ':lua OpenClearTerminal("horizontal")<CR>')

--open terminal vertical
map("n", "<leader>ty", ':lua OpenClearTerminal("vertical")<CR>')
