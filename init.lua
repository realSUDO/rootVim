vim.cmd("set mouse=a")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop")
vim.cmd("set shiftwidth=4")
vim.cmd("set smarttab")
vim.cmd("set autoindent")
vim.cmd("set number")

require("config.lazy")
require("lazy").setup("plugins")

-- setting clangformat gnu
