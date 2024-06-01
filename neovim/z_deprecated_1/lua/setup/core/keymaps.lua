local tools = require("tools")

-- Change leader to a comma
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local function default_opts_desc(desc)
  return { desc = desc, noremap = true, silent = true }
end
local default_opts = { noremap = true, silent = true }

-- Map Esc to jk
map("i", "jk", "<Esc>")

-- Keep cursor in the middle
map("n", "<C-d>", "<C-d>zz", default_opts)
map("n", "<C-u>", "<C-u>zz", default_opts)

-- Keep search term in the middle of the screen
map("n", "n", "nzzzv", default_opts)
map("n", "N", "Nzzzv", default_opts)

-- Keep cursor in the beginning
map("n", "J", "mzJ`z", default_opts)
map("v", "J", ":m '>+1<CR>gv=gv", default_opts)
map("v", "K", ":m '<-2<CR>gv=gv", default_opts)

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", default_opts_desc("Prev buffer"))
map("n", "<S-l>", "<cmd>bnext<cr>", default_opts_desc("Next buffer"))
map("n", "<leader>bb", "<cmd>e #<cr>", default_opts_desc("Switch to Other Buffer"))

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", default_opts_desc("Increase window height"))
map("n", "<C-Down>", "<cmd>resize -2<cr>", default_opts_desc("Decrease window height"))
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", default_opts_desc("Decrease window width"))
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", default_opts_desc("Increase window width"))

-- exit terminal
map("t", "jk", "<C-\\><C-n>", default_opts_desc("Exit terminal mode"))

-- Close all others buffer
-- Reference "https://tech.serhatteker.com/post/2020-06/close-all-buffers-but-current-in-vim/"
map("n", "<leader>bd", "<cmd>%bd|e#|bd#<cr>", default_opts_desc("[b]uffer [d]elete others folder"))

-- Don't copy the replaced text after pasting.
map("v", "p", '"_dP')

-- With this you can use > < multiple time for changing indent when you visual selected text.
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Open current buffer folder in Windows Explorer
map("n", "<F4>", "<cmd>!start explorer %:p:h<cr>", default_opts_desc("Open current buffer directory in Windows explorer."))
