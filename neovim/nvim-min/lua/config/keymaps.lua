local defaults = require("config.defaults")

local function descs(desc)
  desc = desc or "which_key_ignore"
  return { desc = desc, noremap = true, silent = true }
end

-- Map Esc to jk ⤵
vim.keymap.set("i", "jk", "<Esc>", descs())

-- exit terminal ⤵
vim.keymap.set("t", "jk", "<C-\\><C-n>", descs("Exit terminal mode"))

-- Move current line with context aware ⤵
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Don't copy the replaced text after pasting. ⤵
vim.keymap.set("v", "p", '"_dP')

-- https://www.reddit.com/r/neovim/comments/13y3thq/comment/jmm7tut/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button ⤵
-- Keep cursor at the current position after yanking ⤵
vim.keymap.set("v", "y", "ygv<esc>")

-- Clear highlight ⤵
vim.keymap.set({ "n", "v" }, "<leader>cl", "<cmd>:nohl<cr>", descs("[c]lear high[l]ights"))

-- Keep cursor in the middle ⤵
vim.keymap.set("n", "<C-d>", "<C-d>zz", descs())
vim.keymap.set("n", "<C-u>", "<C-u>zz", descs())

-- Keep cursor in the column 0 when [J]oining line below with current one ⤵
vim.keymap.set("n", "J", "mzJ`z", descs())

-- Open Current Working Directory In VSCode ⤵
vim.keymap.set("n", "<F3>", "<cmd>silent !code " .. vim.fn.getcwd() .. "<cr>", descs("Open current working directory in VSCode."))

-- Open current buffer folder in Windows Explorer ⤵
vim.keymap.set("n", "<F4>", "<cmd>!start explorer %:p:h<cr>", descs("Open current buffer directory in Windows explorer."))

-- better up/down ⤵
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Resize window using <ctrl> arrow keys ⤵
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- better indenting ⤵
vim.keymap.set("v", "<", "<gv", descs())
vim.keymap.set("v", ">", ">gv", descs())

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n ⤵
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- buffers ⤵
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", descs("[b]uffer [p]revious"))
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", descs("[b]uffer [n]ext"))
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", descs("switch to other [b]uffer"))
vim.keymap.set("n", "<leader>bc", "<cmd>bp|bd #<cr>", descs("[b]uffer [c]lose without closing split"))
-- https://vi.stackexchange.com/a/2127 ⤵
vim.keymap.set("n", "<leader>bf", "<cmd>:call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{\"bufnr\": v:val}')) | copen<cr>", descs("[b]uffer [f]ind in quick list"))
-- Reference "https://tech.serhatteker.com/post/2020-06/close-all-buffers-but-current-in-vim/" ⤵
vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", descs("delete [o]ther [b]uffers"))

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
    -- go({ severity = severity })
    go()
  end
end
vim.keymap.set("n", "<leader>dgt", function()
  if vim.diagnostic.config().virtual_text then
    vim.diagnostic.config({ virtual_text = false })
  else
    vim.diagnostic.config(defaults.diagnostic)
  end
  -- vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end, { desc = "Toggle Virtual Text Diagnostics" })
vim.keymap.set("n", "<leader>dgl", function() vim.diagnostic.open_float { border="rounded" } end, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
-- with split keyboard ⤵
vim.keymap.set("n", "]5", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[5", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]8", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[8", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]7", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[7", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quickfix list ⤵
vim.keymap.set("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
vim.keymap.set("n", "[`", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]`", vim.cmd.cnext, { desc = "Next Quickfix" })

