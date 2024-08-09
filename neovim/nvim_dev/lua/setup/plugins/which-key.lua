local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      window = {
        border = "rounded",
      },
    },
    config = function()
      local wk = require("which-key")
      wk.add({
        { --buffer
          "<leader>b",
          desc = "+buffer",
          mode = "n",
        },
        { -- Clear
          "<leader>c",
          desc = "+clear",
          mode = "n",
        },
        { -- QuickFix
          "<leader>q",
          desc = "+quickfix",
          mode = "n",
        },
        { --Find files/themes/buffer using telescope
          "<leader>f",
          desc = "+find (files/themes/buffer)",
          mode = "n",
        },
        { -- Winbar / Breadcrumb navigation
          "<leader>w",
          desc = "+winbar/breadcrumb",
          mode = "n",
        },
        { -- Surround
          "<leader>r",
          desc = "+surround",
          mode = "n",
        },
        { -- git, mini.align, open in browser
          "<leader>g",
          desc = "+prefix / git / mini.align / open in browser",
          mode = "n",
        },
        { -- Docstring
          "<leader>d",
          desc = "+docstring",
          mode = { "n" },
        },
        { -- Format
          "<leader>m",
          desc = "+format",
          mode = { "n" },
        },
        { -- LSP
          "<leader>l",
          desc = "+LSP",
          mode = { "n", "v" },
        },
      })
    end,
  }
  return data
end

return M
