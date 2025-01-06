-- Change leader to a comma
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Example to disable plugin
    -- { require("setup.plugins.markdown").init({ enable = false }) },

    -- Misc
    { require("setup.plugins.misc.telescope").init({ enable = true }) },
    -- { require("setup.plugins.misc.nvim-web-devicons").init({ enable = true }) },
    { require("setup.plugins.misc.snacks").init({ enable = true }) },

    -- GIT
    { require("setup.plugins.git.git").init({ enable = true }) },

    -- Themes
    { require("setup.plugins.misc.theme").init({ enable = true }) },

    -- UI
    { require("setup.plugins.ui.lualine").init({ enable = true }) }, -- statusbar
    { require("setup.plugins.ui.file-explorer").init({ enable = true }) }, -- file explorer
    -- { require("setup.plugins.ui.nvim-tree").init({ enable = true }) }, -- file explorer


    -- Code
    { require("setup.plugins.code.treesitter").init({ enable = true }) },
    { require("setup.plugins.code.lsp").init({ enable = true }) }, -- main LSP
    -- { require("setup.plugins.code.lazydev").init({ enable = true }) },
    { require("setup.plugins.code.dropbar").init({ enable = true }) }, -- winbar / breadcrumb
    { require("setup.plugins.code.autoformatter").init({ enable = true }) },
    { require("setup.plugins.code.neogen").init({ enable = true }) }, -- docstring generator
    { require("setup.plugins.code.tiny-code-action").init({ enable = true }) }, -- docstring generator
    { require("setup.plugins.code.garbage-day").init({ enable = true }) }, -- docstring generator
    -- { require("setup.plugins.code.debugger").init({ enable = true }) }, -- docstring generator
    -- { require("setup.plugins.code.lspsaga").init({ enable = true }) },
    -- { require("setup.plugins.code.aerial").init({ enable = true }) },
    { require("setup.plugins.code.markdown").init({ enable = true }) },
    { require("setup.plugins.code.autocompleter").init({ enable = true }) },
    -- -- { require("setup.plugins.code.chatgpt").init({ enable = true }) },

    -- QoL
    { require("setup.plugins.qol.autopairs").init({ enable = true }) },
    -- { require("setup.plugins.qol.colorizer").init({ enable = true }) },
    -- { require("setup.plugins.qol.colortils").init({ enable = true }) },
    { require("setup.plugins.qol.deadcolumn").init({ enable = true }) },
    { require("setup.plugins.qol.flash").init({ enable = true }) },
    { require("setup.plugins.qol.hlslens").init({ enable = true }) },
    { require("setup.plugins.qol.local_highlight").init({ enable = true }) },
    { require("setup.plugins.qol.marks").init({ enable = true }) },
    -- { require("setup.plugins.qol.mini-indent").init({ enable = true }) },
    { require("setup.plugins.qol.mini-surround").init({ enable = true }) },
    { require("setup.plugins.qol.rainbow-delimiters").init({ enable = true }) },
    { require("setup.plugins.qol.todo_highlight").init({ enable = true }) },
    { require("setup.plugins.qol.trouble").init({ enable = true }) },
    { require("setup.plugins.qol.unfold").init({ enable = true }) },
    { require("setup.plugins.qol.undotree").init({ enable = true }) },
    -- { require("setup.plugins.qol.mini-align").init({ enable = true }) },
    -- { require("setup.plugins.qol.icon-picker").init({ enable = true }) },

    { require("setup.plugins.misc.which-key").init({ enable = true }) },
  },
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
