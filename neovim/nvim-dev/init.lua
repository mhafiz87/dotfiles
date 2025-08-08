-- options
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- relative line numbers
vim.opt.nu = true
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

-- tab
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- file messages
vim.opt.shortmess = "I"

-- signcolumn (always)
vim.opt.signcolumn = "yes"

-- timeout
vim.opt.timeoutlen = 500

-- persist undo
vim.opt.undolevels = 10000
vim.opt.undofile = true
vim.opt.undodir = vim.fn.getcwd() .. "/.nvim/undo"

-- command line completion
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "fuzzy,pum,tagfile"

-- window
vim.opt.winborder = "rounded"

-- utility

-- autocmds

-- keymap
vim.keymap.set("i", "jk", "<Esc>")
