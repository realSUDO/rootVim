local fn = vim.fn
local env = vim.env

-- Utility to check if a command exists
local function executable(cmd)
  return fn.executable(cmd) == 1
end

-- Detect environment
local is_mac     = vim.loop.os_uname().sysname == "Darwin"
local is_wayland = env.WAYLAND_DISPLAY ~= nil
local is_x11     = env.DISPLAY ~= nil and not is_wayland

-- Clipboard config logic
if is_mac and executable("pbcopy") then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }

elseif is_wayland and executable("wl-copy") and executable("wl-paste") then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy"
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste"
    },
    cache_enabled = 0,
  }

elseif is_x11 and executable("xclip") then
  vim.g.clipboard = {
    name = "xclip",
    copy = {
      ["+"] = "xclip -selection clipboard",
      ["*"] = "xclip -selection primary"
    },
    paste = {
      ["+"] = "xclip -selection clipboard -o",
      ["*"] = "xclip -selection primary -o"
    },
    cache_enabled = 0,
  }

elseif is_x11 and executable("xsel") then
  vim.g.clipboard = {
    name = "xsel",
    copy = {
      ["+"] = "xsel --clipboard --input",
      ["*"] = "xsel --primary --input"
    },
    paste = {
      ["+"] = "xsel --clipboard --output",
      ["*"] = "xsel --primary --output"
    },
    cache_enabled = 0,
  }

else
  vim.notify("No suitable clipboard provider found", vim.log.levels.WARN)
end
