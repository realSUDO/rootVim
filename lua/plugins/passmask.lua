return {
	dir = vim.fn.isdirectory(vim.fn.expand("~/.local/share/nvim/passmask")) == 1 
		and "~/.local/share/nvim/passmask" 
		or vim.fn.isdirectory(vim.fn.expand("~/CrazyProjects/passmask")) == 1 
		and "~/CrazyProjects/passmask"
		or nil,
	cond = function()
		return vim.fn.isdirectory(vim.fn.expand("~/.local/share/nvim/passmask")) == 1 
			or vim.fn.isdirectory(vim.fn.expand("~/CrazyProjects/passmask")) == 1
	end,
}
