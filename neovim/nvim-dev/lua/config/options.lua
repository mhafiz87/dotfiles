local default_options = require("config.default-options")
local utils = require("utils")

-- options
-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- enable mouse support in all modes
vim.opt.mouse = "a"

-- show current line numbers
vim.opt.nu = true
-- relative line numbers
vim.opt.rnu = true

-- use global clipboard
vim.opt.clipboard = "unnamedplus"

-- autocomplete
vim.opt.completeopt = "fuzzy,menu,menuone,noinsert,noselect,popup"

-- search
vim.opt.ignorecase = true

-- minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 8
-- minimal number of screen columns to keep to the left and to the right of the cursor
vim.opt.sidescrolloff = 8

-- disable wrap
vim.opt.wrap = false

-- guicursor
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,\z
a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,\z
sm:block-blinkwait175-blinkoff150-blinkon175"

-- tab / indent
vim.opt.smartindent = true
vim.opt.expandtab = true  -- use spaces instead of tab
vim.opt.shiftwidth = 4  -- tab size
vim.opt.softtabstop = 4  -- tab size

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- file messages
vim.opt.shortmess:append({W = true, I = true, c = true, C = true })

-- signcolumn (always)
vim.opt.signcolumn = "auto:2-3"

-- timeout
vim.opt.timeoutlen = 500

-- persist undo
vim.opt.undolevels = 10000
vim.opt.undofile = true
vim.opt.undodir = vim.fn.getcwd() .. "/.nvim/undo"

-- command line completion
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "fuzzy,pum,tagfile"

-- show tab as '>', trailing whitespace as '━', nbsp as '+'
vim.opt.list = true
vim.opt.listchars = "tab:<->,trail:-,nbsp:+,extends:🠞,precedes:🠈"
vim.api.nvim_set_hl(0, "NonText", { fg = "#908caa" })

-- window
vim.opt.winborder = "rounded"

-- diagnostics
vim.diagnostic.config(default_options.diagnostic)

if utils.is_windows then
    vim.g.python3_host_prog = vim.fn.getenv("USERPROFILE") .. "\\.venv\\neovim\\scripts\\python.exe"
elseif utils.is_linux then
    vim.g.python3_host_prog = os.getenv("HOME") .. "/.venv/neovim/bin/python"
end
