-- If i want continous comments on pressing enter.. just remove the extension from here.. 
local comment_config = {
	lua = "-- %s",
	c = "// %s",
	cpp = "// %s",
	javascript = "// %s",
	javascriptreact = "// %s",  -- Fixed: JSX also uses //, not #
	typescript = "// %s",
	typescriptreact = "// %s",
	python = "# %s",
}



vim.api.nvim_create_autocmd("FileType", {
	pattern = vim.tbl_keys(comment_config),
	callback = function()
		local ft = vim.bo.filetype
		vim.bo.commentstring = comment_config[ft]
		vim.bo.formatoptions = vim.bo.formatoptions:gsub("[ro]", "")
	end,
})
