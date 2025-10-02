return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    image = { enabled = true },
    picker = { enabled = true },
    statuscolumn = {
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = true, -- show open fold icons
        git_hl = true, -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 50, -- refresh at most every 50ms
    },
    zen = {
      toggles = {
        git_signs = true,
        mini_diff_signs = true,
        diagnostics = true
      },
      show = {
        statusline = true,
        tabline = true
      }
    }
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
    { "<leader>fw", function() Snacks.picker.grep({buffers=true}) end, desc = "[f]ind [w]ords in current buffer" },
    { "<leader>fe", function() Snacks.picker.explorer() end, desc = "[f]ile [e]xplorer" },
    -- grep
    { "<leader>/", function() Snacks.picker.grep() end, desc = "grep" },
    -- git
    { "<leader>ghf", function() Snacks.picker.git_diff() end, desc = "[g]it [h]unk [f]ind" },
    { "<leader>ghs", function() Snacks.picker.git_status() end, desc = "[g]it [h]unk [s]tatus" },
    { "<leader>ghb", function() Snacks.picker.git_branches() end, desc = "[g]it [h]unk [b]ranches" },
    { "<leader>ghd", function() Snacks.picker.git_diff() end, desc = "[g]it [h]unk [d]iff" },
    -- lsp
    { "grd", function() Snacks.picker.lsp_definitions() end, desc = "lsp definitions" },
    { "grD", function() Snacks.picker.lsp_declarations() end, desc = "lsp declarations" },
    { "grr", function() Snacks.picker.lsp_references() end, desc = "lsp references" },
    { "gri", function() Snacks.picker.lsp_implementations() end, desc = "lsp implementation" },
    -- toggle
    { "<leader>tz", function() Snacks.zen() end, desc = "[t]oggle [z]en" },
    -- marks
  },
  config = function (_, opts)
    local snacks = require("snacks")
    snacks.setup(opts)
  end
}
