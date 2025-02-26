-- Define the CompileAndRun function to compile or execute code based on file type
function CompileAndRun()
	-- Function to get the root directory of the project
	local function get_project_root()
		-- Helper function to check if a directory is a Git repository
		local function is_git_repo(path)
			return vim.fn.isdirectory(path .. "/.git") == 1
		end

		-- Get the current directory of the open file
		local current_dir = vim.fn.expand("%:p:h")
		local root = current_dir

		-- Traverse up the directory tree until reaching the root directory or finding a Git repo
		while root ~= "/" do
			if is_git_repo(root) then
				return root -- Return the Git root if found
			end
			root = vim.fn.fnamemodify(root, ":h") -- Move up one directory level
		end

		-- If no Git repo is found, return the current working directory as the project root
		return vim.fn.getcwd()
	end




	-- Python Path Variable
	local pythonPath = "~/.globalPython/bin/python"



	-- Function to create a directory for compiled files in the project root if it doesn’t exist
	local function ensure_compiled_files_dir()
		local project_root = get_project_root()
		local compiled_files_dir = project_root .. "/compiledFiles"
		if vim.fn.isdirectory(compiled_files_dir) == 0 then
			vim.fn.mkdir(compiled_files_dir, "p") -- Create the directory if it doesn’t exist
		end
		return compiled_files_dir
	end

	local compiled_files_dir = nil
	-- Set the compiled files directory only for C/C++ files
	if vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
		compiled_files_dir = ensure_compiled_files_dir()
	end

	-- Compile and run code based on the file type
	if vim.bo.filetype == "c" then
		-- Define the output binary path within the compiled files directory
		local output = compiled_files_dir .. "/" .. vim.fn.expand("%:t:r")
		vim.cmd("w") -- Save the file
		vim.cmd("!gcc % -o " .. output) -- Compile the C file with gcc
		if vim.v.shell_error == 0 then
			-- If compilation succeeds, open a split terminal and run the output file
			vim.cmd("belowright 13split | terminal " .. output)
		else
			-- Display an error message if compilation fails
			vim.api.nvim_echo({ { "Compilation failed!", "ErrorMsg" } }, false, {})
		end
	elseif vim.bo.filetype == "cpp" then
		-- Define the output binary path within the compiled files directory
		local output = compiled_files_dir .. "/" .. vim.fn.expand("%:t:r")
		vim.cmd("w") -- Save the file
		vim.cmd("!g++ % -o " .. output) -- Compile the C++ file with g++
		if vim.v.shell_error == 0 then
			-- If compilation succeeds, open a split terminal and run the output file
			vim.cmd("belowright 13split | terminal " .. output)
		else
			-- Display an error message if compilation fails
			vim.api.nvim_echo({ { "Compilation failed!", "ErrorMsg" } }, false, {})
		end
	elseif vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" then
		-- For JavaScript/TypeScript, open a split terminal and run the file with Node.js
		vim.cmd("belowright 13split | terminal node %")
	elseif vim.bo.filetype == "python" or vim.bo.filetype == "py" then
		-- For Python, open a split terminal and run the file with Python interpreter
		vim.cmd("belowright 13split | terminal" .. pythonPath .. " %")
	elseif vim.bo.filetype == "bash" or vim.bo.filetype == "sh" then
		-- For Bash , open a split terminal and run the file with bash interpreter
		vim.cmd("belowright 13split | terminal bash %" )
	elseif vim.bo.filetype == "html" then
		vim.cmd("w") -- Save the HTML file
		-- Open a split terminal and serve the HTML file with live-server
		vim.cmd("belowright 13split | terminal live-server ")
	end
end
