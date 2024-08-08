local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "stevearc/aerial.nvim",
    event = "BufReadPre",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local aerial = require("aerial")
      aerial.setup({
        on_attach = function(bufnr)
          vim.keymap.set("n", "{", "<CMD>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<CMD>AerialNext<CR>", { buffer = bufnr })
        end,
        layout = {
          default_direction = "prefer_left",
          -- max_width = 30,
          -- width = nil,
          -- min_width = 30,
          -- resize_to_contents = false,
        },
        disable_max_lines = 100000,
        disable_max_size = 2000000,
      })
      vim.keymap.set("n", "<leader>at", "<CMD>AerialToggle!<CR>", { desc = "[a]erial [t]oggle" })
    end,
  }
  return data
end

return M
