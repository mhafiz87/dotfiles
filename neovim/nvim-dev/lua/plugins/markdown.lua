return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    config = function()
      vim.fn["mkdp#util#install"]()
      vim.keymap.set("n", "<leader>mdp", "<CMD>MarkdownPreviewToggle<CR>")
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "light"
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { "markdown" },
    config = function()
      require('render-markdown').setup({
        on_attach = function(bufnr)
          vim.keymap.set("n", "<leader>mdr", require("render-markdown").toggle,
            { desc = "[m]arkdown [r]ender", buffer = bufnr })
        end
      })
    end,
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    config = function()
      require("markdown").setup({
        on_attach = function(bufnr)
          -- local function toggle(key)
          --   return "<Esc>gv<Cmd>lua require'markdown.inline'" .. ".toggle_emphasis_visual'" .. key .. "'<CR>"
          -- end
          vim.keymap.set("n", "<leader>mdc", "<cmd>MDInsertToc<cr>", { desc = "Insert table of content", buffer = bufnr })
          vim.keymap.set("n", "<leader>mdo", "<cmd>MDToc<cr>", { desc = "View table of content content", buffer = bufnr })
          vim.keymap.set("n", "<leader>mds", "<cmd>MDTaskToggle<cr>", { desc = "Toggle task", buffer = bufnr })
          vim.keymap.set("x", "<leader>mds", ":TaskToggle<cr>", { desc = "Toggle task", buffer = bufnr })
          -- vim.keymap.set("x", "<c-b>", toggle("b"), { buffer = bufnr })
          -- vim.keymap.set("x", "<c-i>", toggle("i"), { buffer = bufnr })
          -- vim.keymap.set("x", "<c-s>", toggle("s"), { buffer = bufnr })
          -- vim.keymap.set("x", "<c-c>", toggle("c"), { buffer = bufnr })
        end,
      })
    end,
  },
  {
    "bullets-vim/bullets.vim",
    ft = "markdown",
    config = function ()
      vim.g.bullets_delete_last_bullet_if_empty = 1
    end
  }
}

