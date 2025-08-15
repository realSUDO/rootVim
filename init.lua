--[[
  Neovim Configuration 👾👾 
  Maintained by: realSUDO (https://github.com/realSUDO)

  A clean, modular configuration for Neovim with:
  - Sensible defaults
  - Plugin management via Lazy.nvim
  - Custom keybindings
  - Language-specific configurations
--]]

-- ======================
-- Core Editor Settings
-- ======================
vim.cmd("set mouse=a")            -- Enable mouse support in all modes
vim.cmd("set tabstop=4")          -- Number of spaces a TAB counts for
vim.cmd("set softtabstop=4")      -- Number of spaces for tab/backspace ops
vim.cmd("set shiftwidth=4")       -- Number of spaces for autoindent
vim.cmd("set smarttab")           -- Smart tab handling at start of line
vim.cmd("set autoindent")         -- Maintain indent on new lines
vim.cmd("set number")             -- Show absolute line numbers
vim.wo.relativenumber = true      -- Show relative line numbers (window-local)

-- ======================
-- Plugin Management
-- ======================
require("config.lazy")            -- Lazy.nvim bootstrap configuration
require("lazy").setup("plugins")  -- Initialize plugin manager with plugin specs

-- ======================
-- Custom Configurations
-- ======================
require("config.keybinding")      -- Custom key mappings and shortcuts
require("config.compileandrun")   -- Compilation/execution utilities (clang-format GNU)
require("config.myterminal")      -- Terminal integration and management
require("config.snippets")       -- Code snippet configurations
require("config.comments")       -- Enhanced comment functionality
require("config.clipboard")      -- Clipboard integration settings
require("config.theme-selector") -- Theme selection and management
require("config.current-theme") -- Load current theme settings


-- ======================
-- Toggle Features
-- ======================
require("config.toggleCopilot")   -- GitHub Copilot integration toggle
require("config.flashYanked")     -- Visual feedback for yanked text
require("config.toggleWrap")      -- Smart text wrapping toggle
vim.cmd("Copilot disable")		  -- Disable copilot on startup



-- realsudo out ✌️(ツ)_/¯
-- "Works on my machine" certified™
