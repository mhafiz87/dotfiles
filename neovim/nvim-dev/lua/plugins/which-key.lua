return {
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
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
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
      { --diagnostics/debugger
        "<leader>d",
        desc = "+diagnostics/debugger",
        mode = "n",
      },
    })
  end
}