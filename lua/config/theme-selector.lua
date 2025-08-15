-- lua/config/theme-selector.lua
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local theme_file = vim.fn.stdpath("config") .. "/lua/config/current-theme.lua"

local function save_theme(theme)
	local file = io.open(theme_file, "w")
	if file then
		file:write(string.format('vim.cmd("colorscheme %s")\n', theme))
		file:close()
	end
end

local function load_themes()
	local themes = vim.fn.getcompletion("", "color")
	table.sort(themes)
	return themes
end

local function theme_selector()
	local themes = load_themes()
	local original_theme = vim.g.colors_name or "default"

	pickers
		.new({}, {
			prompt_title = "Theme Selector",
			finder = finders.new_table({ results = themes }),
			sorter = conf.generic_sorter({}),
			layout_config = {
				width = 0.3, -- Take up 50% of the screen width
				height = 0.7, -- Take up 70% of the screen height
				preview_width = 0.55, -- Give more space to preview
				anchor = "NE", -- Anchor to North-East (top-right)
				mirror = false, -- Do not mirror the layout 
				prompt_position = "top", -- Position the prompt at the top
				horizontal = {
					preview_width = 0.55, -- Preview width in horizontal layout
					mirror = false, -- Do not mirror the horizontal layout
				},
				vertical = {
					preview_height = 0.4, -- Preview height in vertical layout
					mirror = false, -- Do not mirror the vertical layout
				},

			},
			layout_strategy = "vertical", -- Vertical split layout
			attach_mappings = function(prompt_bufnr, map)
				local function preview_theme()
					local entry = action_state.get_selected_entry()
					if entry and entry[1] ~= vim.g.colors_name then
						pcall(vim.cmd, "colorscheme " .. entry[1])
					end
				end

				-- Wrap navigation keys for instant preview
				map("i", "<Down>", function()
					actions.move_selection_next(prompt_bufnr)
					preview_theme()
				end)
				map("i", "<Up>", function()
					actions.move_selection_previous(prompt_bufnr)
					preview_theme()
				end)
				map("i", "<C-n>", function()
					actions.move_selection_next(prompt_bufnr)
					preview_theme()
				end)
				map("i", "<C-p>", function()
					actions.move_selection_previous(prompt_bufnr)
					preview_theme()
				end)

				-- Normal mode navigation preview
				map("n", "j", function()
					actions.move_selection_next(prompt_bufnr)
					preview_theme()
				end)
				map("n", "k", function()
					actions.move_selection_previous(prompt_bufnr)
					preview_theme()
				end)

				-- Confirm selection
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if selection then
						pcall(vim.cmd, "colorscheme " .. selection[1])
						save_theme(selection[1])
					end
				end)

				-- Cancel → revert
				map("i", "<Esc>", function()
					pcall(vim.cmd, "colorscheme " .. original_theme)
					actions.close(prompt_bufnr)
				end)

				map("n", "<Esc>", function()
					pcall(vim.cmd, "colorscheme " .. original_theme)
					actions.close(prompt_bufnr)
				end)

				return true
			end,
		})
		:find()
end

vim.api.nvim_create_user_command("ThemeSelector", theme_selector, {})
