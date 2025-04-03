return {
	"andweeb/presence.nvim", --loading presence.nvim for rich presence
	config = function()
		local lines = require("extras.rich-presence-lines") -- open rich_presence-lines in lines

		math.randomseed(vim.loop.hrtime()) --start the randomizer
		local random_line = lines[math.random(#lines)] -- pick a random line in random_line

		require("presence").setup({
			workspace_text = "Architecting Chaos",
			editing_text = random_line,
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
