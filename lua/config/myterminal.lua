function OpenClearTerminal(direction)
  if direction == 'horizontal' then
    vim.cmd("belowright 13split | terminal")
  elseif direction == 'vertical' then
    vim.cmd("vsplit | terminal")
  end
  -- Run the clear command and stay in insert mode
  vim.api.nvim_feedkeys("i clear\n", "n", false)
end
