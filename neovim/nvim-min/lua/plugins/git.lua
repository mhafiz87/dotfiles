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
    -- version = "1.0.1",
    commit = "*",  -- to get the latest commit
    config = function()
      local gitsigns = require("gitsigns")
      local snacks_exist, snacks = pcall(require, "snacks")
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
        preview_config = {
          border = "rounded"
        },
        on_attach = function(bufnr)
          if (snacks_exist) then
            vim.keymap.set(
              "n",
              "<leader>gh.",
              function()
                require("which-key").show(
                  {
                    keys = "<leader>gh",
                    loop = true
                  }
                )
              end,
              {
                buffer = bufnr,
                desc = "enable hydra mode"
              }
            )
          end
          vim.keymap.set(
            "n",
            "<leader>ghp",
            function()
              gitsigns.prev_hunk()
              vim.cmd(":sleep 50m")
              vim.cmd("norm! zz")
            end,
            {
              buffer = bufnr,
              desc = "[g]it [h]unk [p]revious"
            }
          )
          vim.keymap.set(
            "n",
            "<leader>ghn",
            function()
              gitsigns.next_hunk()
              vim.cmd(":sleep 50m")
              vim.cmd("norm! zz")
            end,
            {
              buffer = bufnr,
              desc = "[g]it [h]unk [n]ext"
            }
          )
          vim.keymap.set(
            "n",
            "<leader>ghr",
            gitsigns.preview_hunk,
            {
              buffer = bufnr,
              desc = "[g]it [h]unk p[r]eview"
            }
          )
        end,
      })
    end
  },
}