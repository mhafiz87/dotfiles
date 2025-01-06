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

  -- Code
  { require("setup.plugins.code.lsp").init({ enable = true }) }, -- main LSP
  { require("setup.plugins.code.lspsaga").init({ enable = true }) },
  { require("setup.plugins.code.autocompleter").init({ enable = true }) },
  { require("setup.plugins.code.dropbar").init({ enable = true }) }, -- winbar / breadcrumb
  { require("setup.plugins.code.neogen").init({ enable = true }) }, -- docstring generator
  { require("setup.plugins.code.treesitter").init({ enable = true }) },
  { require("setup.plugins.code.autoformatter").init({ enable = true }) },

  -- UI
  { require("setup.plugins.ui.telescope").init({ enable = true }) },
  { require("setup.plugins.ui.lualine").init({ enable = true }) }, -- statusbar
  { require("setup.plugins.ui.nvim-tree").init({ enable = true }) }, -- statusbar

  -- QoL
  { require("setup.plugins.qol.autopairs").init({ enable = true }) },
  { require("setup.plugins.qol.rainbow-delimiters").init({ enable = true }) },
  { require("setup.plugins.qol.colorizer").init({ enable = true }) },
  { require("setup.plugins.qol.colortils").init({ enable = true }) },
  { require("setup.plugins.qol.mini-indent").init({ enable = true }) },
  { require("setup.plugins.qol.mini-surround").init({ enable = true }) },
  { require("setup.plugins.qol.deadcolumn").init({ enable = true }) },
  { require("setup.plugins.qol.local_highlight").init({ enable = true }) },
  { require("setup.plugins.qol.marks").init({ enable = true }) },
  { require("setup.plugins.qol.todo_highlight").init({ enable = true }) },
  { require("setup.plugins.qol.unfold").init({ enable = true }) },
  { require("setup.plugins.qol.flash").init({ enable = true }) },
  { require("setup.plugins.qol.undotree").init({ enable = true }) },
  { require("setup.plugins.qol.zenmode").init({ enable = true }) },

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
