local utils = require("utils")
local defaults = require("config.defaults")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- use system clipboard ⤵
vim.opt.clipboard = "unnamedplus"

-- enable mouse ⤵
vim.opt.mouse = "a"  -- enable mouse

-- Better Tab Completion ⤵
-- Shows completion menu ONLY when there's more than one match ⤵
-- Prevents automatic selection of the first item ⤵
vim.opt.completeopt = "menuone,noselect,fuzzy,popup"
-- Completes the common part, list matching item, completes matching ⤵
vim.opt.wildmode = "longest:full,full"

-- line numbers ⤵
vim.opt.relativenumber = true

-- tab options ⤵
vim.opt.expandtab = true  -- Use spaces instead of tabs
vim.opt.tabstop = 4

-- search options ⤵
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"  -- preview incremental

-- number of lines/characters to keep visible when scrolling ⤵
vim.opt.scrolloff = 8  -- vertical lines
vim.opt.sidescrolloff = 8  -- horizontal characters

-- sign column ⤵
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time

-- status line ⤵

-- split ⤵
vim.opt.splitbelow = true  -- put new window below current
vim.opt.splitright = true  -- put new window right of current
vim.opt.splitkeep = "screen"

-- blinking cursor ⤵
vim.opt.guicursor = "n-v-sm:block,c-i-ci-ve:ver25,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

-- window style ⤵
vim.opt.winborder = "rounded"
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.termguicolors = true -- True color support

-- Persist Undo ⤵
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.undodir = vim.fn.getcwd() .. "/.nvim/undo"

-- diagnostics ⤵
vim.diagnostic.config(defaults.diagnostic)

if utils.is_windows then
    vim.g.python3_host_prog = vim.fn.getenv("USERPROFILE") .. "\\.venv\\neovim\\scripts\\python.exe"
elseif utils.is_linux then
    vim.g.python3_host_prog = os.getenv("HOME") .. "/.venv/neovim/bin/python"
end
