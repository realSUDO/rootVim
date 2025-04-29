local M = {}

M.ToggleCopilot = function()
	local status = vim.g.copilot_enabled
	if status == 1 then
		vim.cmd("Copilot disable")
		vim.g.copilot_enabled = 0
	    print("Copilot disabled ⭕")
	else
		vim.cmd("Copilot enable")
		vim.g.copilot_enabled = 1
	    print("Copilot enabled ✅")
	end
end

return M
