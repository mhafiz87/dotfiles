return {
  "nvim-treesitter/nvim-treesitter-context",
  priority = 995,
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    max_lines = 5,
  }
}