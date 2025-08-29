return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = { enabled = true },
  },
  keys = {
    -- buffers
    { "<leader>bf", function() Snacks.picker.buffers() end, desc = "[b]uffer [f]ind" },
    -- find
    { "<leader>ff", function() Snacks.picker.files() end, desc = "[f]ind [f]iles" },
    -- git
    { "<leader>ghf", function() Snacks.picker.git_diff() end, desc = "[g]it [h]unk [f]ind" },
    -- lsp
    { "<leader>grr", function() Snacks.picker.lsp_references() end, desc = "lsp references" },
    { "<leader>gri", function() Snacks.picker.lsp_implementations() end, desc = "lsp implementationj" },
    -- diagnostic
  },
  config = function (_, opts)
    local snacks = require("snacks")
    snacks.setup(opts)
  end
}
