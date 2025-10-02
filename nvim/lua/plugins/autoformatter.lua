return {
  "stevearc/conform.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
  config = function(_, opts)
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        lua = { "sytlua" },
        python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
      },
    })
    vim.keymap.set({"n", "v"}, "<leader>mp",function ()
      conform.format({
        lsp_fallback = true,
        async = true,
        timeout_ms = 2000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end
}
