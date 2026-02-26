return {
  enabled = true,
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    { "saghen/blink.compat", opts = { enable_events = true } },
    'hrsh7th/cmp-cmdline',
    'rafamadriz/friendly-snippets',
    "xzbdmw/colorful-menu.nvim",
    "fang2hou/blink-copilot"
  },

  -- use a release tag to download pre-built binaries
  version = '1.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      -- show/hide/select completion
      ["<C-space>"] = { 'show_and_insert', 'show_documentation', 'hide_documentation'},
      ["<C-e>"] = { 'hide' },
      ["<Esc>"] = { 'cancel', 'fallback' },
      ["<Enter>"] = { 'select_and_accept', 'fallback' },
      ["<C-y>"] = { 'select_and_accept' },
      -- navigate options
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev' },
      ['<C-n>'] = { 'select_next' },
      ['<Tab>'] = {
        function(cmp)
          if vim.b[vim.api.nvim_get_current_buf()].nes_state then
            cmp.hide()
            return (
              require("copilot-lsp.nes").apply_pending_nes()
              and require("copilot-lsp.nes").walk_cursor_end_edit()
            )
          end
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'select_next',
        'snippet_forward',
        'fallback'
      },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      -- navigate documentation
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' }
    },

    appearance = {
      nerd_font_variant = 'normal'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      accept = {
        auto_brackets = {
          enabled = true
        }
      },
      -- 'prefix' will fuzzy match on the text before the cursor
      -- 'full' will fuzzy match on the text before _and_ after the cursor
      -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      keyword = { range = "full" },
      documentation = {
        auto_show = true
      },
      ghost_text = { enabled = true },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        }
      },
      menu = {
        auto_show = true,
        draw = {
          -- without 'colorful-menu'
          -- columns = {
          --   { "label", "label_description", gap = 1 },
          --   { "kind_icon", "kind", "source_name", gap = 1 }
          -- },
          -- with 'colorful-menu'
          -- We don't need label_description now because label and label_description are already
          -- combined together in label by colorful-menu.nvim.
          columns = {
            { "kind_icon" },
            { "label", "source_name" ,gap = 1 },
          },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
    },
    signature = { enabled = true },
    cmdline = {
      completion = {
        menu = {
          auto_show = true
        },
        ghost_text = { enabled = true },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        }
      },
      keymap = {
        -- navigating options
        ['<Tab>'] = {
          function(cmp)
            if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then return cmp.accept() end
          end,
          'show_and_insert',
          'select_next',
        },
        ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<Right>'] = { 'select_next', 'fallback' },
        ['<Left>'] = { 'select_prev', 'fallback' },
        -- show|hide|accept completion
        ['<C-space>'] = { 'show', 'fallback' },
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-e>'] = { 'cancel' },
        -- #TODO: WIP
        -- ['<Enter>'] = { 'select_accept_and_enter' },:
        -- ['<Enter>'] = {
        --   function(cmp)
        --     if cmp.is_menu_visible() then
        --       return cmp.select_and_accept()
        --     end
        --   end,
        --   "fallback",
        -- },
      },
      sources = { "buffer", "cmdline" },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lazydev', 'copilot', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 101,
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
        lsp = {
          name = "lsp",
          module = "blink.cmp.sources.lsp",
          score_offset = 99,
        },
        path = {
          name = "path",
          module = "blink.cmp.sources.path",
          score_offset = 98,
        },
        buffer = {
          name = "buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = 97,
        },
        cmdline = {
          name = "cmdline",
          module = "blink.compat.source",
          score_offset = 95,
          enabled = function ()
            return vim.fn.getcmdtype() == ":"
          end
        },
      }
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}
