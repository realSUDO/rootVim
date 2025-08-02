-- keybinding.lua
-- realSUDO's cheat codes for nvim ✨

local toggleCopilot = require("config.toggleCopilot")

-- Mini-map-maker (because typing full commands is for noobs)
local function map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

-- Window-hopping (like tabs but cooler)
map("n", "<C-h>", "<C-w>h") -- ←
map("n", "<C-j>", "<C-w>j") -- ↓
map("n", "<C-k>", "<C-w>k") -- ↑ 
map("n", "<C-l>", "<C-w>l") -- →

-- Terminal tricks
map("t", "<leader>tt", "<C-\\><C-n>")      -- Proper terminal exit
map("n", "<leader>tt", '<cmd>lua OpenClearTerminal("h")<CR>') -- Split me
map("n", "<leader>ty", '<cmd>lua OpenClearTerminal("v")<CR>') -- Split me sideways

-- Magic buttons
map("n", "<C-p>", "<cmd>Telescope find_files<CR>") -- Find All The Things™
map("n", "<leader><leader><leader>r", "<cmd>w | lua CompileAndRun()<CR>") -- Compile-go-brrr

-- Toggle-ables (FIXED)
vim.keymap.set("n", "<leader><leader>co", toggleCopilot.ToggleCopilot, { desc = "AI go brrr" })
map("n", "<leader>tw", "<cmd>lua require('toggleWrap').toggle()<CR>", { desc = "Wrap it like burrito" })

-- Pro tip: Now you can type these with BOTH hands while drinking coffee ☕

