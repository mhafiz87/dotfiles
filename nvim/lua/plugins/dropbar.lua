return {
  "bekaboo/dropbar.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {},
  opts = {},
  keys = {
    { "<leader>wb", function() require("dropbar.api").pick() end, desc = "Winbar navigation", noremap = true, silent = true },
  },
}