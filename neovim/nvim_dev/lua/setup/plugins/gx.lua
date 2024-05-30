return {
  "chrishrb/gx.nvim",
  cmd = { "Browse" },
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true, -- default settings
  submodules = false, -- not needed, submodules are required only for tests
  config = function()
    require("gx").setup({})
  end,
}
