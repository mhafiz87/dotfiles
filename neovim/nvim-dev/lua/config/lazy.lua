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
    -- { require("setup.plugins.code.tiny-code-action").init({ enable = true }) },
    { require("plugins.misc.which-key").init({ enable = true }) },
    { require("plugins.misc.themery").init({ enable = true }) },
    { require("plugins.git.git").init({ enable = true }) },
    { require("plugins.misc.lualine").init({ enable = true }) },
    { require("plugins.misc.snacks").init({ enable = true }) },
    { require("plugins.code.lsp").init({ enable = true }) },
    { require("plugins.code.treesitter").init({ enable = true }) },
    { require("plugins.code.dropbar").init({ enable = true }) },
    { require("plugins.misc.bullets").init({ enable = true }) },
    { require("plugins.misc.colorizer").init({ enable = true }) },
    { require("plugins.misc.flash").init({ enable = true }) },
    { require("plugins.misc.hlslens").init({ enable = true }) },
    { require("plugins.misc.marks").init({ enable = true }) },
    { require("plugins.misc.mini-surround").init({ enable = true }) },
    { require("plugins.misc.rainbow-delimiters").init({ enable = true }) },
    { require("plugins.misc.todo_highlight").init({ enable = true }) },
    { require("plugins.misc.trouble").init({ enable = true }) },
    { require("plugins.misc.unfold").init({ enable = true }) },
    { require("plugins.code.autocompleter-blink").init({ enable = true }) },
    { require("plugins.code.autocompleter-cmp").init({ enable = false }) },
    { require("plugins.code.autoformatter").init({ enable = true }) },
    { require("plugins.code.garbage-day").init({ enable = true }) },
    { require("plugins.code.markdown").init({ enable = true }) },
    { require("plugins.code.neogen").init({ enable = true }) },
    { require("plugins.code.autopair").init({ enable = true }) },
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
