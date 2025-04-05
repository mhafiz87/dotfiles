return {
  {
    "sindrets/diffview.nvim",
    event = { "BufReadPost" },
    opts = {},
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
  {
    'lewis6991/gitsigns.nvim',
    priority = 997,
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "|" },
      },
      current_line_blame = true,
      signcolumn = true,
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "<leader>gp", function()
          vim.notify("gitsigns plugin is loaded !!!")
          gitsigns.prev_hunk()
          gitsigns.preview_hunk()
          vim.cmd(":sleep 100m")
          vim.cmd("norm! zz")
        end, { buffer = bufnr, desc = "[g]o to [p]revious Hunk" })
        vim.keymap.set("n", "<leader>gn", function()
          gitsigns.next_hunk()
          gitsigns.preview_hunk()
          vim.cmd(":sleep 100m")
          vim.cmd("norm! zz")
        end, { buffer = bufnr, desc = "[g]o to [n]ext Hunk" })
        vim.keymap.set("n", "<leader>gh", gitsigns.preview_hunk, { buffer = bufnr, desc = "View [g]it [h]unk" })
        vim.keymap.set("n", "<leader>gr", gitsigns.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle [g]it [b]lame" })
      end
    }
  },
}