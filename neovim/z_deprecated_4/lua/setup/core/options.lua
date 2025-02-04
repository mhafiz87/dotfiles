local global = require("global")
-- Sync With System Clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.termguicolors = true
vim.opt.colorcolumn = "80"

-- Top / Bottom Scroll Off
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Set highlight on search
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable Mouse Mode
vim.opt.mouse = "a" -- Enable mouse mode

-- Disable Wrap
vim.opt.wrap = false

-- Line Numbers
vim.opt.number = true         -- Print line number
vim.opt.relativenumber = true -- Relative line numbers

-- Better Completion Experience
vim.opt.completeopt = "menu,menuone,noselect"

-- Disable nvim intro
vim.opt.shortmess:append("sI")

-- Memory / CPU Optimization
-- vim.opt.lazyredraw = true       -- Faster scrolling
vim.opt.synmaxcol = 240 -- Max column for syntax highlight

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250

-- Auto Reload File If Content Changes From Outside
vim.o.autoread = true

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Blinking cursor
vim.o.guicursor = "n-v-sm:block,c-i-ci-ve:ver25,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

if global.is_windows then
  vim.g.python3_host_prog = os.getenv("userprofile") .. "\\.venv\\neovim\\scripts\\python.exe"
elseif global.is_linux then
  vim.g.python3_host_prog = os.getenv("HOME") .. "/.venv/neovim/bin/python"
end
