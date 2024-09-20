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

require("lazy").setup(
  {
    -- Example to disable plugin
    -- { require("setup.plugins.markdown").init({ enable = false }) },

    -- Markdown
    { require("setup.plugins.markdown").init({}) },
    { require("setup.plugins.markdown-viewer").init({}) },
    -- UI
    { require("setup.plugins.themery").init({}) },
    { require("setup.plugins.lualine").init({}) },
    { require("setup.plugins.telescope").init({}) },
    -- Code
    { require("setup.plugins.treesitter").init({}) },
    { require("setup.plugins.lsp").init({}) },
    { require("setup.plugins.autocompleter").init({}) },
    -- Document Generator
    { require("setup.plugins.neogen").init({}) },
    -- AutoFormatter
    { require("setup.plugins.conform").init({}) },
    -- Code Navigation
    { require("setup.plugins.barbecue").init({}) },
    { require("setup.plugins.navbuddy").init({}) },
    -- Git
    { require("setup.plugins.git.gitsigns").init({}) },
    { require("setup.plugins.git.vim-fugitive").init({}) },
    { require("setup.plugins.git.diffview").init({}) },
    -- { require("setup.plugins.git.vgit").init({}) },
    -- Noice
    { require("setup.plugins.noice").init({}) },
    -- QoL
    { require("setup.plugins.qol.todo_highlight").init({}) },
    { require("setup.plugins.qol.unfold").init({}) },
    { require("setup.plugins.qol.trouble").init({}) }, -- List diagnostic in a pretty way.
    { require("setup.plugins.qol.gx").init({}) },
    { require("setup.plugins.qol.mini-align").init({}) },
    { require("setup.plugins.qol.mini-indent").init({}) },
    { require("setup.plugins.qol.mini-surround").init({}) },
    { require("setup.plugins.qol.colorizer").init({}) },
    { require("setup.plugins.qol.colortils").init({}) },
    { require("setup.plugins.qol.deadcolumn").init({}) },
    { require("setup.plugins.qol.flash").init({}) },
    { require("setup.plugins.qol.oil").init({}) },
    { require("setup.plugins.qol.aerial").init({}) },
    { require("setup.plugins.qol.autopairs").init({}) },
    { require("setup.plugins.qol.marks").init({}) },
    { require("setup.plugins.qol.local_highlight").init({}) },
    -- { require("setup.plugins.qol.multicursor").init({}) },
    -- { require("setup.plugins.qol.stay_centered").init({}) },
    -- Which Key (Must be last to override others)
    { require("setup.plugins.qol.which_key").init({}) },
  },
  {
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
  }
)
