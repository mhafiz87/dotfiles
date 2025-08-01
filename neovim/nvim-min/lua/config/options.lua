local utils = require("utils")
local defaults = require("config.defaults")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- Better Tab Completion ⤵
-- Shows completion menu ONLY when there's more than one match ⤵
-- Prevents automatic selection of the first item ⤵
opt.completeopt = "menuone,noselect,fuzzy,popup"

opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99

-- search options ⤵
opt.ignorecase = true -- ignore case in search pattern
opt.inccommand = "nosplit" -- preview incremental substitute

opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler

-- number of line/char to keep visible when scrolling 
opt.scrolloff = 8 -- vertical (lines)
opt.sidescrolloff = 8 -- horizontal (char)

opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent

-- Suppress 'written', 'introductory', 'completion',
opt.shortmess:append({ W = true, I = true, c = true })

opt.showmode = false -- Dont show mode since we have a statusline
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }

-- split behaviour
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.splitkeep = "screen"

opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support

opt.timeoutlen = vim.g.vscode and 1000 or 300
-- opt.timeoutlen = 500

opt.updatetime = 250 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.sidescrolloff = 8 -- Columns of context

-- blinking cursor ⤵
opt.guicursor = "n-v-sm:block,c-i-ci-ve:ver25,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
opt.winborder = "rounded"

-- Persist Undo ⤵
opt.undofile = true
opt.undolevels = 10000
opt.undodir = vim.fn.getcwd() .. "/.nvim/undo"

-- diagnostics ⤵
vim.diagnostic.config(defaults.diagnostic)

if utils.is_windows then
    vim.g.python3_host_prog = vim.fn.getenv("USERPROFILE") .. "\\.venv\\neovim\\scripts\\python.exe"
elseif utils.is_linux then
    vim.g.python3_host_prog = os.getenv("HOME") .. "/.venv/neovim/bin/python"
end
