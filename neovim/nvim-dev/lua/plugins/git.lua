local utils = require("utils")

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
    event = "BufReadPre",
    version = "1.0.1",
    -- commit = "7ce11ab",
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "|" },
        },
        signs_staged = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "|" },
        },
        signs_staged_enable = true,
        auto_attach = true,
        current_line_blame = true,
        signcolumn = true,
        on_attach = function(bufnr)
          -- if utils.is_plugin_installed("gitsigns.nvim") == true then
          --   local Snacks = require("snacks")
          --   Snacks.notify("[gitsigns] gitsigns plugin is installed !!!")
          -- end
          vim.keymap.set("n", "<leader>gp", function()
            vim.notify("gitsigns plugin is loaded !!!")
            gitsigns.prev_hunk()
            vim.cmd(":sleep 50m")
            vim.cmd("norm! zz")
          end, { buffer = bufnr, desc = "[g]o to [p]revious Hunk" })
          vim.keymap.set("n", "<leader>gn", function()
            gitsigns.next_hunk()
            vim.cmd(":sleep 50m")
            vim.cmd("norm! zz")
          end, { buffer = bufnr, desc = "[g]o to [n]ext Hunk" })
          vim.keymap.set("n", "<leader>gh", gitsigns.preview_hunk, { buffer = bufnr, desc = "View [g]it [h]unk" })
          vim.keymap.set("n", "<leader>gr", gitsigns.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle [g]it [b]lame" })
        end,
      })
    end
  },
}
