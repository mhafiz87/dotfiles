local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
      },
    },
    config = function()
      require("dropbar").setup({})
      vim.keymap.set("n", "<leader>wb", require("dropbar.api").pick, { desc = "Winbar navigation", noremap = true, silent = true })
    end,
  }
  return data
end

return M
