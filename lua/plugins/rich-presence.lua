return {
	"andweeb/presence.nvim",
	config = function()
		local lines = require("extras.rich-presence-lines")

		math.randomseed(vim.loop.hrtime())
		local pair = lines.paired_texts[math.random(#lines.paired_texts)]
		local random_editing = pair.editing[math.random(#pair.editing)]

		require("presence").setup({
			workspace_text = pair.workspace,
			editing_text = random_editing,
			file_explorer_text = "Lost in the filesystem...",
			git_commit_text = "Sealing the fate of this repo!",
			plugin_manager_text = "Injecting steroids in Neovim...",
			line_number_text = "On line %d , re-writing the history...",
			neovim_image_text = "Vibing with neovim",
			main_image = "file",
			buttons = {
				{ label = "Check out Neovim", url = "https://neovim.io" },
			},
		})
	end,
}
