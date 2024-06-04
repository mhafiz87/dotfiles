local M = {}

function M.init (args)
  setmetatable(args, {__index={enable=true}})
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
    config = function ()
      local wk = require("which-key")
      wk.register({
        -- Buffers Controls
        ["<leader>b"] = {
          name = "+buffer controls",
          mode = "n",
        },

        -- Clear
        ["<leader>c"] = {
          name = "+clear",
          mode = "n",
        },

        -- Git
        ["<leader>g"] = {
          name = "+git",
          mode = "n",
        },

        -- Flash
        ["<leader>h"] = {
          mode = "n",
          name = "+flash",
        },

        -- Quickfix
        ["<leader>q"] = {
          mode = "n",
          name = "+quickfix",
        },

        -- Find files/themes/buffer using telescope
        ["<leader>f"] = {
          mode = "n",
          name = "+find (files/themes/buffer)",
        },

        -- Trouble
        ["<leader>x"] = {
          mode = "n",
          name = "+trouble",
        },

        -- LSP
        ["<leader>l"] = {
          mode = {"n", "v"},
          name = "+LSP",
        },

        -- Format
        ["<leader>m"] = {
          mode = {"n", "v"},
          name = "+format",
        },

        -- g
        g = {
          mode = {"n"},
          name = "+prefix / mini.align / open in browser",
        },

        -- Surround
        ["<leader>r"] = {
          mode = {"n", "v"},
          name = "+surround",
        }
      })
    end
  }
  return data
end

return M

