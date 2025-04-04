return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local ntt = require("nvim-treesitter.textobjects.move")
    vim.keymap.set(
      "n", "]-", function ()
        ntt.goto_next_start("@function.outer")
        vim.cmd(":sleep 100m")
        vim.cmd("norm! zz")
      end,
      { desc = "Go to next function", noremap = true, silent = true }
    )
    vim.keymap.set(
      "n", "[-", function ()
        ntt.goto_previous_start("@function.outer")
        vim.cmd(":sleep 100m")
        vim.cmd("norm! zz")
      end,
      { desc = "Go to next function", noremap = true, silent = true }
    )
    vim.keymap.set(
      "n", "}", function ()
        ntt.goto_next_start("@block.outer")
        vim.cmd(":sleep 100m")
        vim.cmd("norm! zz")
      end,
      { desc = "Go to next block", noremap = true, silent = true }
    )
    vim.keymap.set(
      "n", "{", function ()
        ntt.goto_previous_start("@block.outer")
        vim.cmd(":sleep 100m")
        vim.cmd("norm! zz")
      end,
      { desc = "Go to next block", noremap = true, silent = true }
    )
  end
}