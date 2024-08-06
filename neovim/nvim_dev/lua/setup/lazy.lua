-- Change leader to a comma
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Example to disable plugin
  -- { require("setup.plugins.markdown").init({ enable = false }) },
  -- Git
  { require("setup.plugins.git.gitsigns").init({}) },
  { require("setup.plugins.git.vim-fugitive").init({}) },
  { require("setup.plugins.git.diffview").init({}) },
  -- Code
  { require("setup.plugins.code.treesitter").init({}) },
  { require("setup.plugins.code.autocompleter").init({}) },
  { require("setup.plugins.code.lspsaga").init({ enable = true }) },
  { require("setup.plugins.code.glance").init({}) },
  { require("setup.plugins.code.conform").init({}) },
  -- UI
  { require("setup.plugins.ui.lualine").init({}) },
  { require("setup.plugins.ui.themery").init({}) },
  { require("setup.plugins.ui.telescope").init({}) },
  { require("setup.plugins.ui.nvim-tree").init({}) },
  { require("setup.plugins.ui.noice").init({}) },
  { require("setup.plugins.ui.dropbar").init({}) },
  -- QoL
  { require("setup.plugins.qol.aerial").init({}) },
  { require("setup.plugins.qol.autopairs").init({}) },
  { require("setup.plugins.qol.deadcolumn").init({}) },
  { require("setup.plugins.qol.colorizer").init({}) },
  { require("setup.plugins.qol.colortils").init({}) },
  { require("setup.plugins.qol.flash").init({}) },
  { require("setup.plugins.qol.gx").init({}) },
  { require("setup.plugins.qol.local_highlight").init({}) },
  { require("setup.plugins.qol.marks").init({}) },
  { require("setup.plugins.qol.markdown").init({}) },
  { require("setup.plugins.qol.markdown-viewer").init({}) },
  { require("setup.plugins.qol.mini-align").init({}) },
  { require("setup.plugins.qol.mini-indent").init({}) },
  { require("setup.plugins.qol.mini-surround").init({}) },
  { require("setup.plugins.qol.neogen").init({}) },
  { require("setup.plugins.qol.todo_highlight").init({}) },
  { require("setup.plugins.qol.trouble").init({}) },
  { require("setup.plugins.qol.unfold").init({}) },
  -- Which Key (Must be last to override others)
  { require("setup.plugins.qol.which_key").init({}) },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = "rounded",
  },
})
