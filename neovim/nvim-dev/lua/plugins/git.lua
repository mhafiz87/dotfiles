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
      local is_snacks, Snacks = pcall(require, "snacks")
      local is_which_key, which_key = pcall(require, "which-key")
      local is_miniclue, miniclue = pcall(require, "mini.clue")
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
          if is_which_key then
            if is_snacks then
              Snacks.notify("[gitsigns] which-key installed !!!")
            end
            vim.keymap.set("n", "<leader>gh[", function()
              which_key.show({ keys = "<leader>gh", loop = true })
              vim.schedule(function()
                gitsigns.prev_hunk()
                vim.cmd(":sleep 50m")
                vim.cmd("norm! zz")
              end)
            end, { buffer = bufnr, desc = "[g]o to [p]revious Hunk" })
            vim.keymap.set("n", "<leader>gh]", function()
              which_key.show({ keys = "<leader>gh", loop = true })
              vim.schedule(function()
                gitsigns.next_hunk()
                vim.cmd(":sleep 50m")
                vim.cmd("norm! zz")
              end)
            end, { buffer = bufnr, desc = "[g]o to [n]ext Hunk" })
            vim.keymap.set("n", "<leader>gh", gitsigns.preview_hunk, { buffer = bufnr, desc = "View [g]it [h]unk" })
          elseif is_miniclue then
            vim.keymap.set("n", "<leader>gh[", function()
                gitsigns.prev_hunk()
                vim.cmd(":sleep 50m")
                vim.cmd("norm! zz")
              end,
              { buffer = bufnr, desc = "[g]o to [p]revious hunk" }
            )
            vim.keymap.set("n", "<leader>gh]", function()
                gitsigns.next_hunk()
                vim.cmd(":sleep 50m")
                vim.cmd("norm! zz")
              end,
              { buffer = bufnr, desc = "[g]o to [n]ext hunk" }
            )
          else
            vim.keymap.set("n", "<leader>gp", function()
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
          end
        end,
      })
    end
  },
}
