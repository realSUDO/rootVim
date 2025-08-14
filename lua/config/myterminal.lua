local M = {}

function M.OpenClearTerminal(direction)
  if direction == 'horizontal' then
    vim.cmd("belowright 13split | terminal")
  elseif direction == 'vertical' then
    vim.cmd("vsplit | terminal")
  end

  vim.api.nvim_feedkeys("clear\n", "n", false)
  vim.cmd("startinsert")
end

return M

