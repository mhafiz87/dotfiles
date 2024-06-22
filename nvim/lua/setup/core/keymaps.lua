local tools = require("tools")

-- Change leader to a comma
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local function default_opts_desc(desc)
  return { desc = desc, noremap = true, silent = true }
end
local default_opts = { desc = "which_key_ignore", noremap = true, silent = true }

-- Map Esc to jk
map("i", "jk", "<Esc>", default_opts)

-- Clear highlight
map({ "n", "v" }, "<leader>cl", "<cmd>:nohl<cr>", default_opts_desc("[c]lear high[l]ights"))

-- Keep cursor in the middle
map("n", "<C-d>", "<C-d>zz", default_opts)
map("n", "<C-u>", "<C-u>zz", default_opts)

-- Keep search term in the middle of the screen
map("n", "n", "nzzzv", default_opts)
map("n", "N", "Nzzzv", default_opts)

-- Keep cursor in the column 0 when [J]oining line below with current one
map("n", "J", "mzJ`z", default_opts)

-- Move current line with context aware
map("v", "J", ":m '>+1<CR>gv=gv", default_opts)
map("v", "K", ":m '<-2<CR>gv=gv", default_opts)

-- buffers
map("n", "<leader>bp", "<cmd>bprevious<cr>", default_opts_desc("[b]uffer [p]revious"))
map("n", "<leader>bn", "<cmd>bnext<cr>", default_opts_desc("[b]uffer [n]ext"))
map("n", "<leader>bb", "<cmd>e #<cr>", default_opts_desc("switch to other [b]uffer"))
map("n", "<leader>bc", "<cmd>bp|bd #<cr>", default_opts_desc("[c]lose [b]uffer without closing split"))
-- Reference "https://tech.serhatteker.com/post/2020-06/close-all-buffers-but-current-in-vim/"
map("n", "<leader>bd", "<cmd>%bd|e#|bd#<cr>", default_opts_desc("[d]elete other [b]uffers"))

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", default_opts_desc("Increase window height"))
map("n", "<C-Down>", "<cmd>resize -2<cr>", default_opts_desc("Decrease window height"))
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", default_opts_desc("Decrease window width"))
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", default_opts_desc("Increase window width"))

-- exit terminal
map("t", "jk", "<C-\\><C-n>", default_opts_desc("Exit terminal mode"))

-- Don't copy the replaced text after pasting.
map("v", "p", '"_dP', default_opts)

-- With this you can use > < multiple time for changing indent when you visual selected text.
map("v", "<", "<gv", default_opts)
map("v", ">", ">gv", default_opts)

-- Open current buffer folder in Windows Explorer
map("n", "<F4>", "<cmd>!start explorer %:p:h<cr>",
  default_opts_desc("Open current buffer directory in Windows explorer."))

-- Search for highlighted text in buffer
-- map("n", "//", 'y/<c-r>"<cr>', default_opts_desc("Search for highlighted in current buffer"))

-- Replace word under cursor across entire buffer
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  default_opts_desc("Replace word under cursor across entire buffer"))

-- Quickfix
map("n", "<leader>qn", "<cmd>cnext<cr>zz", default_opts_desc("[n]ext quickfix list"))
map("n", "<leader>qp", "<cmd>cprev<cr>zz", default_opts_desc("[p]revious quickfix list"))

-- Diagnostic
map("n", "[d", vim.diagnostic.goto_prev, default_opts_desc("Go to previous diagnostic"))
map("n", "]d", vim.diagnostic.goto_prev, default_opts_desc("Go to next diagnostic"))
