local M = {}

-- Define custom highlight for Yanked text (black text, white background)
vim.cmd([[
  highlight YankHighlight guifg=#000000 guibg=#FFFFFF gui=bold
]])

-- Optionally, neutralize default Search/IncSearch highlight to avoid color conflict
vim.cmd([[
  highlight Search guifg=#FFFFFF guibg=#000000
  highlight IncSearch guifg=#FFFFFF guibg=#000000
]])

-- Set autocmd to highlight yanked text with custom color
M.HighlightYankedText = function()
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 100 })
    end,
    desc = "Highlight on yank"
  })
end

-- Automatically trigger the highlighting function
M.HighlightYankedText()

return M

