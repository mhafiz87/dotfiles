local tools = require("tools")

vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.colorcolumn = "80,88,120"

vim.keymap.set("n", "<leader>td", tools.toggle_all_python_docstring, { noremap = true, desc = "[t]toggle [d]ocstring", silent = true })
vim.keymap.set("n", "<leader>rf", "<cmd>cexpr system('refurb --quiet ' . shellescape(expand('%'))) | copen<cr>", { noremap = true, desc = "[r]e[f]urb", silent = true })
vim.keymap.set("v", "<leader>mb", tools.format_selected_lines_using_black, { noremap = true, desc = "For[m]at selected lines using [b]lack", silent = true })
