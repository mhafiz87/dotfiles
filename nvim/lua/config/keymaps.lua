local defaults = require("config.default-options")

-- bound 'jk' to escape from input mode ⤵
vim.keymap.set("i", "jk", "<Esc>")

-- bound 'jk' to exit terminal ⤵
vim.keymap.set("t", "jk", "<C-\\><C-n>")

-- don't copy the replaced text after pasting. ⤵
vim.keymap.set("v", "p", '"_dP')

-- move current line with context aware (move and reindent) ⤵
-- moves a visually selected block of lines, (:m '>+1<CR>)
-- then re-selects the moved block, re-indents it, (gv=)
-- and re-selects it again for further actions. (gv)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })  -- down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })  -- up

-- https://www.reddit.com/r/neovim/comments/13y3thq/comment/jmm7tut/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button ⤵
-- Keep cursor at the current position after yanking ⤵
vim.keymap.set("v", "y", "ygv<esc>")

-- keep cursor in the middle when move 1/2 page ⤵
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- better up/down when there's a wrapped line ⤵
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr=true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr=true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr=true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr=true })

-- better indenting ⤵
vim.keymap.set("v", "<", "<gv")  -- (indent then reselect)
vim.keymap.set("v", ">", ">gv")  -- (indent then reselect)

-- keep cursor current position when [J]oining line below with current one ⤵
vim.keymap.set("n", "J", "mzJ`z", { desc = "move line below to the end of current line"})

-- 'n' always search forward and 'N' always search backward
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { desc = "search forward", expr = true })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { desc = "search forward", expr = true })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { desc = "search forward", expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { desc = "search backward", expr = true })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { desc = "search backward", expr = true })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { desc = "search backward", expr = true })

-- buffers ⤵
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "[b]uffer [p]revious" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "[b]uffer [n]ext" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "switch to other [b]uffer" })
vim.keymap.set("n", "<leader>bc", "<cmd>bp|bd #<cr>", { desc = "[b]uffer [c]lose without closing split" })
-- https://vi.stackexchange.com/a/2127 ⤵
vim.keymap.set("n", "<leader>bf", "<cmd>:call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{\"bufnr\": v:val}')) | copen<cr>", { desc = "[b]uffer [f]ind in quick list" })
-- Reference "https://tech.serhatteker.com/post/2020-06/close-all-buffers-but-current-in-vim/" ⤵
vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "delete [o]ther [b]uffers" })

-- diagnostics ⤵
local diagnostic_goto = function(next, severity)
  local go = next
    and function ()
      vim.diagnostic.jump ({ count=1, float = { border = "rounded" } })
      vim.cmd("norm! zz")
    end
    or function ()
      vim.diagnostic.jump ({ count=-1, float = { border = "rounded" } })
      vim.cmd("norm! zz")
    end
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
vim.keymap.set("n", "<leader>dgt", function()
  local current_diagnostic_config = vim.diagnostic.config()
  vim.diagnostic.config({ virtual_text = not current_diagnostic_config.virtual_text })
  -- if vim.diagnostic.config().virtual_text then
  --   vim.diagnostic.config({ virtual_text = false })
  -- else
  --   vim.diagnostic.config(defaults.diagnostic)
  -- end
end, { desc = "Toggle Virtual Text Diagnostics" })
vim.keymap.set("n", "<leader>dgl", function() vim.diagnostic.open_float { border="rounded" } end, { desc = "Line Diagnostics" })
vim.keymap.set("n", "dgb", function()
  vim.diagnostic.setqflist({}, { bufnr = vim.api.nvim_get_current_buf() })
end, { desc = "Current Buffer Diagnostic" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
-- with split keyboard ⤵
vim.keymap.set("n", "]5", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[5", diagnostic_goto(false), { desc = "Prev Diagnostic" })

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

