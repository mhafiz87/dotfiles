return {
  -- Show code context at winbar
  {
    "LunarVim/breadcrumbs.nvim",
    enabled = false,
    dependencies = { "SmiteshP/nvim-navic" },
    config = function ()
      require("nvim-navic").setup({
        lsp = {
          auto_attach = true,
        },
      })
      require("breadcrumbs").setup()
    end
  },
  -- Show code context at winbar
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
    config = function()
      require("barbecue").setup({
        create_autocmd = false, -- prevent barbecue from updating itself automatically
      })

      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",

        -- include this if you have set `show_modified` to `true`
        -- "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
  },

  -- Breadcrumbs navigation
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
      "numToStr/Comment.nvim", -- Optional
      "nvim-telescope/telescope.nvim", -- Optional
    },
    opts = { lsp = { auto_attach = true } },
  },

  -- align functionality
  {
    "echasnovski/mini.align",
    event = { "VeryLazy", "BufEnter" },
    version = false,
    config = function()
      local align = require("mini.align")
      align.setup()
    end,
  },

  -- open link in browser
  {
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true, -- default settings
    submodules = false, -- not needed, submodules are required only for tests
    config = function()
      require("gx").setup({})
      vim.keymap.set({ "n", "x" }, "gx", "<cmd>Browse<cr>", { desc = "Browse link in browser", noremap = true, silent = true })
    end,
  },

  -- surround
  {
    'echasnovski/mini.surround',
    event = "VeryLazy",
    version = false,
    config = function ()
      require("mini.surround").setup({
        mappings = {
          add = '<leader>ra', -- Add surrounding in Normal and Visual modes
          delete = '<leader>rd', -- Delete surrounding
          find = '<leader>rf', -- Find surrounding (to the right)
          find_left = '<leader>rF', -- Find surrounding (to the left)
          highlight = '<leader>rh', -- Highlight surrounding
          replace = '<leader>rr', -- Replace surrounding
          update_n_lines = '<leader>rn', -- Update `n_lines`
		},
      })
    end
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

      local cmp_exist, cmp = pcall(require, "cmp")
      if (cmp_exist) then
        -- import nvim-autopairs completion functionality
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        -- make autopairs and completion work together
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- file explorer
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "which_key_ignore", noremap = true, silent = true })
      })
    end
  },

  -- flash
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {},
    keys = {
      {
        "<leader>hs",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<leader>hS",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "<leader>hr",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "<leader>hR",
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

  -- Easier comment/uncomment line
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function ()
      if (vim.version().major == 0 and vim.version().minor < 10)
      then
        require("Comment").setup()
      end
    end,
  },

  -- TODO
  {
    "folke/todo-comments.nvim",
    enabled = true,
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("todo-comments").setup({
            keywords = {
                FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            gui_style = {
                fg = "NONE",                         -- The gui style to use for the fg highlight group.
                bg = "BOLD",                         -- The gui style to use for the bg highlight group.
            },
            merge_keywords = true,                   -- when true, custom keywords will be merged with the defaults
            highlight = {
                multiline = true,                    -- enable multine todo comments
                multiline_pattern = "^.",            -- lua pattern to match the next multiline from the start of the matched keyword
                multiline_context = 10,              -- extra lines that will be re-evaluated when changing a line
                before = "",                         -- "fg" or "bg" or empty
                keyword = "wide",                    -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty.
                after = "fg",                        -- "fg" or "bg" or empty
                pattern = [[.*<(KEYWORDS)\s*:]],     -- pattern or table of patterns, used for highlighting (vim regex)
                comments_only = true,                -- uses treesitter to match keywords in comments only
                max_line_len = 400,                  -- ignore lines longer than this
                exclude = {},                        -- list of file types to exclude highlighting
            },
            -- list of highlight groups or use the hex color if hl not found as a fallback
            colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info = { "DiagnosticInfo", "#2563EB" },
                hint = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
                test = { "Identifier", "#FF00FF" },
            },
        })
    end
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
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
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

