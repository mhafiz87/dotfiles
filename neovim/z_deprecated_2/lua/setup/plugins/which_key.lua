return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    key_labels = {
      -- override the label used to display some keys. It doesn't effect WK in any other way.
      ['<space>'] = 'SPC',
      ['<cr>'] = 'RET',
      ['<tab>'] = 'TAB',
      ['<C>'] = 'CTRL',
    },
    window = {
      border = 'rounded',
    },
  },
  config = function ()
    which_key = require("which-key")
    which_key.register({
      -- Base
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
        mode = "n",
        name = "+LSP",
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
  end,
}

