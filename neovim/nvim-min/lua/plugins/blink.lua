return {
  {
    enabled = true,
    event = { 'InsertEnter', 'CmdlineEnter' },
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      { 'saghen/blink.compat', opts = { enable_events = true } },
    },
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = 'rounded' },
        },
        -- auto insert brackets
        accept = { auto_brackets = { enabled = true } },
        -- don't select by default, auto insert on selection
        list = { selection = { preselect = false, auto_insert = true } },
        menu = {
          border = 'rounded',
          auto_show = true,
          draw = {
            columns = {
              { 'label',     'label_description', gap = 1 },
              { 'kind_icon', 'kind',              'source_name', gap = 1 },
            },
          },
        },
        ghost_text = { enabled = true },
      },
      keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show_and_insert', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<Esc>'] = { 'cancel', 'fallback' },
        ['<Enter>'] = { 'select_and_accept', 'fallback' },

        ['<C-y>'] = { 'select_and_accept' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev' },
        ['<C-n>'] = { 'select_next' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
      signature = {
        enabled = true,
        window = { border = 'rounded' },
      },
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
          ['<Tab>'] = {
            function(cmp)
              if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then return cmp.accept() end
            end,
            'show_and_insert',
            'select_next',
          },
          ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },

          ['<C-space>'] = { 'show', 'fallback' },

          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
          ['<Right>'] = { 'select_next', 'fallback' },
          ['<Left>'] = { 'select_prev', 'fallback' },

          ['<C-y>'] = { 'select_and_accept' },
          ['<C-e>'] = { 'cancel' },
        }
      },
      sources = {
        default = { 'lazydev','lsp', 'path', 'snippets', 'buffer', 'cmdline' },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
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
        },
      },
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)
    end
  },
}
