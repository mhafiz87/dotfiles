local utils = require("utils")
local defaults = require("config.defaults")
local map = vim.keymap.set

local function descs(desc)
  desc = desc or "which_key_ignore"
  return { desc = desc, noremap = true, silent = true }
end

-- Map Esc to jk ⤵
map("i", "jk", "<Esc>", descs())

-- exit terminal ⤵
map("t", "jk", "<C-\\><C-n>", descs("Exit terminal mode"))

-- Move current line with context aware ⤵
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Don't copy the replaced text after pasting. ⤵
map("v", "p", '"_dP')

-- https://www.reddit.com/r/neovim/comments/13y3thq/comment/jmm7tut/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button ⤵
-- Keep cursor at the current position after yanking ⤵
map("v", "y", "ygv<esc>")

-- Clear highlight ⤵
map({ "n", "v" }, "<leader>cl", "<cmd>:nohl<cr>", descs("[c]lear high[l]ights"))

-- Keep cursor in the middle ⤵
map("n", "<C-d>", "<C-d>zz", descs())
map("n", "<C-u>", "<C-u>zz", descs())

-- Keep cursor in the column 0 when [J]oining line below with current one ⤵
map("n", "J", "mzJ`z", descs())

-- Open Current Working Directory In VSCode ⤵
map("n", "<F3>", "<cmd>silent !code " .. vim.fn.getcwd() .. "<cr>", descs("Open current working directory in VSCode."))

-- Open current buffer folder in Windows Explorer ⤵
map("n", "<F4>", "<cmd>!start explorer %:p:h<cr>", descs("Open current buffer directory in Windows explorer."))

-- better up/down ⤵
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys | Define in which-key.lua
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys ⤵
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- better indenting ⤵
map("v", "<", "<gv", descs())
map("v", ">", ">gv", descs())

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n ⤵
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- buffers ⤵
map("n", "<leader>bp", "<cmd>bprevious<cr>", descs("[b]uffer [p]revious"))
map("n", "<leader>bn", "<cmd>bnext<cr>", descs("[b]uffer [n]ext"))
map("n", "<leader>bb", "<cmd>e #<cr>", descs("switch to other [b]uffer"))
map("n", "<leader>bc", "<cmd>bp|bd #<cr>", descs("[b]uffer [c]lose without closing split"))
-- https://vi.stackexchange.com/a/2127 ⤵
map("n", "<leader>bf", "<cmd>:call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{\"bufnr\": v:val}')) | copen<cr>", descs("[b]uffer [f]ind in quick list"))
-- Reference "https://tech.serhatteker.com/post/2020-06/close-all-buffers-but-current-in-vim/" ⤵
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", descs("delete [o]ther [b]uffers"))

-- diagnostics ⤵
local diagnostic_goto = function(next, severity)
  local go = next
    and function ()
      vim.diagnostic.jump ({ count=1, float = { border = "rounded" } })
    end
    or function ()
      vim.diagnostic.jump ({ count=-1, float = { border = "rounded" } })
    end
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>dgt", function()
  if vim.diagnostic.config().virtual_text then
    vim.diagnostic.config({ virtual_text = false })
  else
    vim.diagnostic.config(defaults.diagnostic)
  end
  -- vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end, { desc = "Toggle Virtual Text Diagnostics" })
map("n", "<leader>dgl", function() vim.diagnostic.open_float { border="rounded" } end, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
-- with split keyboard ⤵
map("n", "]5", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[5", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]8", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[8", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]7", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[7", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- location list ⤵
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- quickfix list ⤵
map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
map("n", "[`", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]`", vim.cmd.cnext, { desc = "Next Quickfix" })


-- if utils.is_plugin_installed("snacks.nvim") == true then
--   Snacks.notify("[keymaps] snacks plugin is installed !!!")
-- end
