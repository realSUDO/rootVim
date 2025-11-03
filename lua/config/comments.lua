-- Function to set commentstring and disable auto-comment continuation
local function set_commentstring()
	vim.bo.commentstring = "// %s"
	vim.bo.formatoptions = vim.bo.formatoptions:gsub("[ro]", "")
end

-- Autocommand for C files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "c",
	callback = set_commentstring,
})

-- Autocommand for C++ files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "cpp",
	callback = set_commentstring,
})
