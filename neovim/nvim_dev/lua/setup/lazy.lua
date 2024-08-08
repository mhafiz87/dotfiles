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

  -- Themes
  { require("setup.plugins.themes.themery").init({ enable = true }) },

  -- GIT
  { require("setup.plugins.git.gitsigns").init({ enable = true }) },
  { require("setup.plugins.git.diffview").init({ enable = true }) },

  { require("setup.plugins.code.lsp").init({ enable = true }) }, -- main LSP
  { require("setup.plugins.code.lspsaga").init({ enable = true }) },
  { require("setup.plugins.code.autocompleter").init({ enable = true }) },
  { require("setup.plugins.code.dropbar").init({ enable = true }) }, -- breadcrumb
  { require("setup.plugins.code.treesitter").init({ enable = true }) },

  -- UI
  { require("setup.plugins.ui.telescope").init({ enable = true }) },

  { require("setup.plugins.which-key").init({ enable = true }) },
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
