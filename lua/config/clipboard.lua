-- clipboard.lua
-- realsudo's system-wide yank bank 🏦

local fn = vim.fn
local env = vim.env

-- Can this command run? (Returns: yes/no/maybe)
local function can_run(cmd)
  return fn.executable(cmd) == 1  -- 1 = "I got u fam"
end

-- Detect where we're running
local is_mac = vim.loop.os_uname().sysname == "Darwin"
local is_wayland = env.WAYLAND_DISPLAY ~= nil
local is_x11 = env.DISPLAY ~= nil and not is_wayland

-- MacOS: The bougie clipboard
if is_mac and can_run("pbcopy") then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },  -- Copy ALL the things
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" }, -- Paste ALL the things
    cache_enabled = 0  -- No cache, we die like men
  }

-- Wayland: The new hotness
elseif is_wayland and can_run("wl-copy") then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
    paste = { ["+"] = "wl-paste", ["*"] = "wl-paste" },
    cache_enabled = 0
  }

-- X11: The old reliable (xclip edition)
elseif is_x11 and can_run("xclip") then
  vim.g.clipboard = {
    name = "xclip",
    copy = {
      ["+"] = "xclip -sel clip",  -- For normies
      ["*"] = "xclip -sel primary" -- For hipsters
    },
    paste = {
      ["+"] = "xclip -sel clip -o",
      ["*"] = "xclip -sel primary -o"
    },
    cache_enabled = 0
  }

-- X11: The old reliable (xsel edition)
elseif is_x11 and can_run("xsel") then
  vim.g.clipboard = {
    name = "xsel",
    copy = {
      ["+"] = "xsel --clipboard --input",  -- Ctrl+C
      ["*"] = "xsel --primary --input"     -- Middle click
    },
    paste = {
      ["+"] = "xsel --clipboard --output",
      ["*"] = "xsel --primary --output"
    },
    cache_enabled = 0
  }

else
  vim.notify("No clipboard found - you're living like it's 1999", vim.log.levels.WARN)
end

-- Pro tip: Now yanking works across ALL THE APPS 🎉
