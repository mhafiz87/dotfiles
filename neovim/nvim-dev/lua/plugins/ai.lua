local prefix = "<Leader>a"
local enabled = true

-- if global variable is not nil
-- if vim.g.ai_status ~= nil then
--   enabled = false
-- end

if vim.g.ai_status == 1 then
  enabled = false
end

return {
  {
    "zbirenbaum/copilot.lua",
    enabled = enabled,
    cmd = "Copilot",
    opts = {
      suggestion = { enabled = true },
      panel = { enabled = true },
      filetypes = {
        ["*"] = true,
        ["markdown"] = false,
        ["text"] = false,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      vim.api.nvim_set_keymap("i", prefix .. "c", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end,
  },
  {
    {
      "olimorris/codecompanion.nvim",
      version = "^18.0.0",
      opts = {
        interactions = {
          chat = {
            adapter = {
              name = "copilot",
              model = "sonnet",
            },
          },
          inline = {
            adapter = {
              name = "copilot",
              model = "claude-sonnet-4-5",
            },
          },
          cmd = {
            adapter = {
              name = "copilot",
              model = "claude-sonnet-4-5",
            },
          },
          background = {
            adapter = {
              name = "copilot",
              model = "claude-sonnet-4-5",
            },
          },
        },
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        {
          "MeanderingProgrammer/render-markdown.nvim",
          ft = { "markdown", "codecompanion" },
        },
      },
    },
  },
}
