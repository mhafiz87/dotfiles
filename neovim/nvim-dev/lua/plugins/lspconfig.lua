return {
  enabled = true,
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  config = function()
    local lsp_list = { "lua_ls", "pyright", "ruff", "marksman", "taplo" }
    for index = 1, #lsp_list do
      vim.lsp.enable(lsp_list[index])
    end
  end,
}
