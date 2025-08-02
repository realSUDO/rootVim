local M = {}

-- Default configuration
local default_config = {
  enabled = false, -- Start with wrap off by default
  wrap = true,
  linebreak = true,
  breakindent = true,
  showbreak = "↪  ",
  nolist = true,
}

-- State management
local state = {
  current = vim.deepcopy(default_config),
  original = {}
}

-- Save current settings
local function save_original()
  state.original = {
    wrap = vim.opt.wrap:get(),
    linebreak = vim.opt.linebreak:get(),
    breakindent = vim.opt.breakindent:get(),
    showbreak = vim.opt.showbreak:get(),
    list = vim.opt.list:get(),
  }
end

-- Apply wrap settings
local function apply_settings(config)
  vim.opt.wrap = config.wrap
  vim.opt.linebreak = config.linebreak
  vim.opt.breakindent = config.breakindent
  vim.opt.showbreak = config.showbreak
  vim.opt.list = not config.nolist
end

-- Toggle function
function M.toggle()
  if not state.current.enabled then
    -- First run - save original settings
    if not state.original.wrap then
      save_original()
    end
    apply_settings(default_config)
    state.current.enabled = true
    vim.notify("Text Wrap: ON", vim.log.levels.INFO)
  else
    -- Restore original settings
    apply_settings(state.original)
    state.current.enabled = false
    vim.notify("Text Wrap: OFF", vim.log.levels.INFO)
  end
end

-- Optional setup function for customization
function M.setup(user_config)
  default_config = vim.tbl_deep_extend("force", default_config, user_config or {})
end

return M
