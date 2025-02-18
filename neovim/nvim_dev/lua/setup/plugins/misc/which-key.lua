local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      win = {
        border = "rounded",
        wo = {
          winblend = 50
        }
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { --buffer
          "<leader>b",
          desc = "+buffer",
          mode = "n",
        },
        { --highlight
          "<leader>c",
          desc = "+highlight",
          mode = "n",
        },
        { --theme
          "<leader>f",
          desc = "+themes",
          mode = "n",
        },
        { --quickfix
          "<leader>q",
          desc = "+quickfix",
          mode = "n",
        },
      })
    end,
  }
  return data
end

return M
