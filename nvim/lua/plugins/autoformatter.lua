return {
  "stevearc/conform.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
  config = function(_, opts)
    local conform = require("conform")
    require("conform").setup({
      formatters_by_ft = {
        lua = { "sytlua" },
        python = { "ruff_fix", "ruff_format" },
      },
    })
  end
}
