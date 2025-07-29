local utils = require("utils")

vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.colorcolumn = "80,88,120"

vim.keymap.set("n", "<leader>rf", "<cmd>cexpr system('refurb --quiet ' . shellescape(expand('%'))) | copen<cr>", { noremap = true, desc = "[r]e[f]urb", silent = true })
vim.keymap.set("v", "<leader>mb", utils.format_selected_lines_using_black, { noremap = true, desc = "For[m]at selected lines using [b]lack", silent = true })

-- if utils.is_plugin_installed("pydochide.nvim") == true then
--     vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--         pattern = { "*.py" },
--         command = ":PyDocHide<CR>",
--     })
-- end
