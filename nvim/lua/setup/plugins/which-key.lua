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
        { -- Docstring
          "<leader>d",
          desc = "+debugger/docstring",
          mode = { "n" },
        },
        { --Find files/themes/buffer using telescope
          "<leader>f",
          desc = "+find (files/themes/buffer/notifier/snacks)",
          mode = "n",
        },
        { --find notifer using telescope
          "<leader>fn",
          desc = "+notifier",
          mode = "n",
        },
        { --find git files using telescope
          "<leader>fg",
          desc = "+git",
          mode = "n",
        },
        { --find grep live
          "<leader>fl",
          desc = "+live grep",
          mode = "n",
        },
        { --find git files using telescope
          "<leader>fs",
          desc = "+search string in current directory",
          mode = "n",
        },
        { -- git, mini.align, open in browser
          "<leader>g",
          desc = "+prefix / git / mini.align / open in browser",
          mode = "n",
        },
        { -- LSP
          "<leader>l",
          desc = "+LSP",
          mode = { "n", "v" },
        },
        { -- Format
          "<leader>m",
          desc = "+format / markdown",
          mode = { "n" },
        },
        { -- Surround
          "<leader>r",
          desc = "+surround",
          mode = { "n", "v" },
        },
        { -- Toggle
          "<leader>t",
          desc = "+toggle",
          mode = { "n" },
        },
        { -- Toggle Options
          "<leader>to",
          desc = "+toggle options",
          mode = { "n" },
        },
        { -- QuickFix
          "<leader>q",
          desc = "+quickfix",
          mode = "n",
        },
        { -- Winbar / Breadcrumb navigation
          "<leader>w",
          desc = "+winbar/breadcrumb",
          mode = "n",
        },
        { -- Trouble
          "<leader>x",
          desc = "+trouble",
          mode = { "n" },
        },
      })
    end,
  }
  return data
end

return M
