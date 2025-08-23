-- Define the CompileAndRun function to compile or execute code based on file type
function CompileAndRun()
	-- Get project root (by Git or fallback to cwd)
	local function get_project_root()
		local function is_git_repo(path)
			return vim.fn.isdirectory(path .. "/.git") == 1
		end
		local current_dir = vim.fn.expand("%:p:h")
		local root = current_dir
		while root ~= "/" do
			if is_git_repo(root) then return root end
			root = vim.fn.fnamemodify(root, ":h")
		end
		return vim.fn.getcwd()
	end

	-- Resolve portable python path
	local function get_python_path()
		local packaged = "/usr/share/rootvim/.globalPython/bin/python"
		local global = vim.fn.expand("~/.globalPython/bin/python")

		if vim.fn.filereadable(packaged) == 1 then
			return packaged
		elseif vim.fn.filereadable(global) == 1 then
			return global
		elseif vim.fn.executable("python3") == 1 then
			return vim.fn.exepath("python3")
		else
			vim.notify("[CompileRun] No valid Python interpreter found.", vim.log.levels.WARN)
			return "python3" -- fallback default
		end
	end

	-- For compiled languages: ensure binary dir
	local function ensure_compiled_files_dir()
		local project_root = get_project_root()
		local compiled_dir = project_root .. "/compiledFiles"
		if vim.fn.isdirectory(compiled_dir) == 0 then
			vim.fn.mkdir(compiled_dir, "p")
		end
		return compiled_dir
	end

	local ft = vim.bo.filetype
	local filename = vim.fn.expand("%:t")
	local filename_without_ext = vim.fn.expand("%:t:r")

	-- C / C++
	if ft == "c" or ft == "cpp" then
		local output = ensure_compiled_files_dir() .. "/" .. filename_without_ext
		vim.cmd("w")
		local compile_cmd = (ft == "c" and "gcc" or "g++") .. " % -o " .. output
		vim.cmd("!" .. compile_cmd)
		if vim.v.shell_error == 0 then
			vim.cmd("belowright 13split | terminal " .. output)
		else
			vim.api.nvim_echo({ { "Compilation failed!", "ErrorMsg" } }, false, {})
		end

	-- JS / TS
	elseif ft == "javascript" or ft == "typescript" then
		vim.cmd("belowright 13split | terminal node %")

	-- Python
	elseif ft == "python" or ft == "py" then
		local py = get_python_path()
		vim.cmd("belowright 13split | terminal " .. py .. " %")

	-- Bash / Shell
	elseif ft == "sh" or ft == "bash" then
		vim.cmd("belowright 13split | terminal bash %")

	-- HTML
	elseif ft == "html" then
		vim.cmd("w")
		vim.cmd("belowright 13split | terminal live-server")
	end
end

