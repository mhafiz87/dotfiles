--options
vim.g.mapleader = " "
vim.g.localmapleader = " "

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

-- messages
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })

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

-- keymaps
-- map Escape in insert mode to 'jk'
vim.keymap.set("i", "jk", "<Esc>")
-- source current file
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<cr>")
-- execute current line
vim.keymap.set("n", "<leader>x", ":.lua<cr>")
-- execute selected line
vim.keymap.set("v", "<leader>x", ":lua<cr>")

-- autocmds
-- Don't auto commenting new lines
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "",
  command = "set fo-=c fo-=r fo-=o",
})
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight text when yanking(copying) text",
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = "500" })
  end
})

