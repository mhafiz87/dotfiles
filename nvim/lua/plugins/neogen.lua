return {
  "danymat/neogen",
  event = "BufReadPost",
  dependencies = {
    "L3MON4D3/LuaSnip",
  },
  config = function ()
    local i = require("neogen.types.template").item
    require('neogen').setup({
      snippet_engine = "luasnip",
      languages = {
        python = {
          template = {
            annotation_convention = "google_docstrings",
          },
        },
      },
    })
    vim.keymap.set({ "n", "v" }, "<leader>ds", ":lua require('neogen').generate()<cr>",
      { desc = "Generate Docstring", silent = true })
  end
}
