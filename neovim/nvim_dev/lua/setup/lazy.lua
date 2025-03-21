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
    { require("setup.plugins.misc.snacks").init({ enable = true }) },
    { require("setup.plugins.themes.themery").init({ enable = true }) },
    { require("setup.plugins.git.git").init({ enable = true }) },
    { require("setup.plugins.misc.autopairs").init({ enable = true }) },
    { require("setup.plugins.misc.nvim-web-devicons").init({ enable = true }) },
    { require("setup.plugins.misc.which-key").init({ enable = true }) },
    { require("setup.plugins.code.treesitter").init({ enable = true }) },
    { require("setup.plugins.code.lsp").init({ enable = true }) },
    { require("setup.plugins.misc.mini-surround").init({ enable = true }) },
    { require("setup.plugins.misc.nvim-ufo").init({ enable = true }) },
    { require("setup.plugins.code.autocompleter").init({ enable = true }) },
    { require("setup.plugins.code.autoformatter").init({ enable = true }) },
    { require("setup.plugins.code.debugger").init({ enable = true }) },
    { require("setup.plugins.code.dropbar").init({ enable = true }) },
    { require("setup.plugins.code.garbage-day").init({ enable = true }) },
    { require("setup.plugins.code.markdown").init({ enable = true }) },
    { require("setup.plugins.code.neogen").init({ enable = true }) },
    -- { require("setup.plugins.code.tiny-code-action").init({ enable = true }) },
    { require("setup.plugins.misc.rainbow-delimiters").init({ enable = true }) },
    { require("setup.plugins.misc.hlslens").init({ enable = true }) },
    { require("setup.plugins.misc.unfold").init({ enable = true }) },
    { require("setup.plugins.misc.marks").init({ enable = true }) },
    { require("setup.plugins.misc.flash").init({ enable = true }) },
    { require("setup.plugins.misc.todo_highlight").init({ enable = true }) },
    { require("setup.plugins.misc.trouble").init({ enable = true }) },
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
