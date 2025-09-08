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
    { "<leader>bd", function() Snacks.bufdelete(0) end, desc = "[b]uffer current [d]elete" },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "[b]uffer delete [o]thers" },
    -- diagnostic
    { "<leader>dga", function() Snacks.picker.diagnostics() end, desc = "[d]ia[g]nostic all" },
    { "<leader>dgb", function() Snacks.picker.diagnostics_buffer() end, desc = "[d]ia[g]nostic current [b]uffer" },
    -- find
    { "<leader>ff", function() Snacks.picker.files() end, desc = "[f]ind [f]iles" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "[f]ind [m]arks" },
    -- git
    { "<leader>ghf", function() Snacks.picker.git_diff() end, desc = "[g]it [h]unk [f]ind" },
    { "<leader>ghs", function() Snacks.picker.git_status() end, desc = "[g]it [h]unk [s]tatus" },
    { "<leader>ghb", function() Snacks.picker.git_branches() end, desc = "[g]it [h]unk [b]ranches" },
    { "<leader>ghd", function() Snacks.picker.git_diff() end, desc = "[g]it [h]unk [d]iff" },
    -- lsp
    { "<leader>grd", function() Snacks.picker.lsp_definitions() end, desc = "lsp definitions" },
    { "<leader>grD", function() Snacks.picker.lsp_declarations() end, desc = "lsp declarations" },
    { "<leader>grr", function() Snacks.picker.lsp_references() end, desc = "lsp references" },
    { "<leader>gri", function() Snacks.picker.lsp_implementations() end, desc = "lsp implementation" },
    -- marks
  },
  config = function (_, opts)
    local snacks = require("snacks")
    snacks.setup(opts)
  end
}
