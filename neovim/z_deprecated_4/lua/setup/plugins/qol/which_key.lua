local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
        ["<c>"] = "CTRL",
      },
      window = {
        border = 'rounded',
      },
    },
    config = function()
      local wk = require("which-key")
      wk.add({
        { -- Buffers Controls
          "<leader>b",
          desc = "+buffer controls",
          mode = "n"
        },
        { -- Clear
          "<leader>c",
          desc = "+clear",
          mode = "n"
        },
        { -- Git
          "<leader>g",
          desc = "+git",
          mode = "n"
        },
        { -- Flash
          "<leader>h",
          desc = "+flash",
          mode = "n"
        },
        { -- QuickFix
          "<leader>q",
          desc = "+quickfix",
          mode = "n"
        },
        { --Find files/themes/buffer using telescope
          "<leader>f",
          desc = "+find (files/themes/buffer)",
          mode = "n"
        },
        { -- Trouble
          "<leader>x",
          desc = "+trouble",
          mode = "n"
        },
        { -- Docstring
          "<leader>d",
          desc = "+docstring",
          mode = "n"
        },
        { -- LSP
          "<leader>l",
          desc = "+LSP",
          mode = { "n", "v" }
        },
        { -- Format / Markdown
          "<leader>m",
          desc = "+format / markdown",
          mode = "n"
        },
        { -- g
          "g",
          desc = "+prefix / mini.align / open in browser",
          mode = "n"
        },
        { -- Surround
          "<leader>r",
          desc = "+quickfix",
          mode = { "n", "v" }
        },
      })
    end
  }
  return data
end

return M
