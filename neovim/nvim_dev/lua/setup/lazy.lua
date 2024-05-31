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

-- This has to be set before initializing lazy
vim.g.mapleader = " "

require("lazy").setup(
  {
    {import = "setup.plugins.themes"},
    {import = "setup.plugins.telescope"},
    {import = "setup.plugins.treesitter"},
    {import = "setup.plugins.git"},
    {import = "setup.plugins.surround"},
    {import = "setup.plugins.lsp"},
    {import = "setup.plugins.oil"},
    {import = "setup.plugins.gx"},
    {import = "setup.plugins.align"},
    {import = "setup.plugins.which_key"},
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
