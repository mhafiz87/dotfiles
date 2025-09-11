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
          local which_key_exist, which_key = pcall(require, "which-key")
          if which_key_exist then
            vim.keymap.set(
              "n",
              "<leader>gh.",
              function()
                which_key.show(
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
            "<leader>ghl",
            gitsigns.toggle_current_line_blame,
            { buffer = bufnr, desc = "toggle current [line] blame" }
          )
          vim.keymap.set(
            "n",
            "<leader>ghL",
            gitsigns.blame_line,
            { buffer = bufnr, desc = "blame [L]ine" }
          )
          vim.keymap.set(
            "n",
            "<leader>ghw",
            gitsigns.toggle_word_diff,
            { buffer = bufnr, desc = "toggle [w]ord diff" }
          )
          vim.keymap.set(
            "n",
            "<leader>ghH",
            gitsigns.select_hunk,
            { buffer = bufnr, desc = "select [H]unk" }
          )
          vim.keymap.set(
            "n",
            "<leader>ghS",
            gitsigns.stage_hunk,
            { buffer = bufnr, desc = "[S]tage hunk" }
          )
          vim.keymap.set(
            "n",
            "<leader>ghR",
            gitsigns.reset_hunk,
            { buffer = bufnr, desc = "[R]eset hunk" }
          )
          vim.keymap.set(
            "n",
            "<leader>ghp",
            function()
              gitsigns.nav_hunk("prev")
              vim.cmd(":sleep 50m")
              vim.cmd.normal({"zz", bang = true})
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
              gitsigns.nav_hunk("next")
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
            "<leader>ghv",
            gitsigns.preview_hunk,
            {
              buffer = bufnr,
              desc = "[g]it [h]unk pre[v]iew"
            }
          )
          vim.keymap.set(
            "n",
            "<leader>ghV",
            gitsigns.preview_hunk_inline,
            {
              buffer = bufnr,
              desc = "[g]it [h]unk pre[V]iew inline"
            }
          )
          vim.keymap.set(
            "n",
            "<leader>ghc",
            function ()
              gitsigns.setqflist(0)
            end,
            {
              buffer = bufnr,
              desc = "view current buffer git hunk in [c]uickfix"
            }
          )
          vim.keymap.set(
            "n",
            "<leader>ghC",
            function ()
              gitsigns.setqflist("all")
            end,
            {
              buffer = bufnr,
              desc = "view repo git hunk in [C]uickfix"
            }
          )
        end,
      })
    end
  },
}
