return {
  -- Visualize indent scope
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "BufEnter",
    config = function()
      require("mini.indentscope").setup({
        draw = { animation = require("mini.indentscope").gen_animation.none() },
        symbol = "│",
        options = { try_as_border = true },
      })
    end,
  },

  -- Align lines
  {
    "echasnovski/mini.align",
    version = false,
    event = "BufEnter",
    config = function()
      local align = require("mini.align")
      align.setup()
    end,
  },

  -- Autopair
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local autopair = require("nvim-autopairs")
      autopair.setup({
        check_ts = true,
      })

      -- import nvim-autopairs completion functionality
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      -- import nvim-cmp plugin (completions plugin)
      local cmp = require("cmp")

      -- make autopairs and completion work together
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Easier comment/uncomment line
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Shows Function Table
  {
    "stevearc/aerial.nvim",
    event = "BufReadPre",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local aerial = require("aerial")
      aerial.setup({
        on_attach = function(bufnr)
          vim.keymap.set("n", "{", "<CMD>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<CMD>AerialNext<CR>", { buffer = bufnr })
        end,
        layout = {
          default_direction = "prefer_left",
          -- max_width = 30,
          -- width = nil,
          -- min_width = 30,
          -- resize_to_contents = false,
        },
        disable_max_lines = 100000,
        disable_max_size = 2000000,
      })
      vim.keymap.set("n", "<leader>a", "<CMD>AerialToggle!<CR>", { desc = "Toggle [A]erial" })
    end,
  },

  -- Code Breadcrumbs navigation
  {
    "SmiteshP/nvim-navbuddy",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
      "numToStr/Comment.nvim", -- Optional
      "nvim-telescope/telescope.nvim", -- Optional
    },
    opts = { lsp = { auto_attach = true } },
  },

  -- Display popup of possible key bindings.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  -- Easier navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {},
    keys = {
      {
        "<leader>s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<leader>S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "<leader>r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "<leader>R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- Highlight other uses of the word.
  {
    "tzachar/local-highlight.nvim",
    config = function()
      require("local-highlight").setup()
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = { "*.*" },
        callback = function(data)
          require("local-highlight").attach(data.buf)
        end,
      })
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Fold
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open All Folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close All Folds" })
      vim.keymap.set("n", "zp", require("ufo").peekFoldedLinesUnderCursor, { desc = "[p]eek folded line under cursor" })

      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("↙ %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      local ufo = require("ufo")
      ufo.setup({
        fold_virt_text_handler = handler,
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      })
    end,
  },

  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    event = "VeryLazy",
    config = function()
      vim.fn["mkdp#util#install"]()
      vim.keymap.set("n", "<leader>md", "<CMD>MarkdownPreviewToggle<CR>")
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "light"
    end,
  },

  -- Multiline
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
  },

  -- Pretty Diagnostic List
  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      require("trouble").setup({})
      vim.keymap.set("n", "<leader>tr", "<cmd>TroubleToggle<cr>", { desc = "[t]oggle t[r]ouble"})
    end
  },

  -- Search QoL
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function ()
      require("hlslens").setup()
      vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR><CMD>lua vim.api.nvim_feedkeys('zz', 'n', false)<CR>]], { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR><CMD>lua vim.api.nvim_feedkeys('zz', 'n', false)<CR>]], { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>l', '<cmd>noh<cr>', { noremap = true, silent = true })
    end
  },
}
