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
    {require("setup.plugins.telescope").init({})},
    {require("setup.plugins.lsp").init({})},
    {require("setup.plugins.autocompleter").init({})},
    {require("setup.plugins.barbeque").init({})},
    {require("setup.plugins.navbuddy").init({})},
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
