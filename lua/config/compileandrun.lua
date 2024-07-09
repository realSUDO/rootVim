function CompileAndRun()
	if vim.bo.filetype == "c" then
		local output = vim.fn.expand("%:r")
		vim.cmd("w")                                 -- Save the file
		vim.cmd("!gcc % -o " .. output)              -- Compile the file
		if vim.v.shell_error == 0 then
			vim.cmd("belowright 13split | terminal " .. output) -- Open a split terminal and run the output file
		else
			vim.api.nvim_echo({ { "Compilation failed!", "ErrorMsg" } }, false, {})
		end
	end
end
