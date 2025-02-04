local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    {
      enabled = args.enable,
      "saghen/blink.cmp",
      dependencies = {
        'rafamadriz/friendly-snippets',
        {"saghen/blink.compat", opts = {enable_events = true}},
        "onsails/lspkind.nvim",                -- vs-code like pictograms
        {
          "Exafunction/codeium.nvim",
          dependencies = {
            "nvim-lua/plenary.nvim",
          },
        },
        {
          "folke/lazydev.nvim",
          ft = "lua", -- only load on lua files
          opts = {
            library = {
              -- See the configuration section for more details
              -- Load luvit types when the `vim.uv` word is found
              { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
          },
        },
        "moyiz/blink-emoji.nvim"
      },
      version = "*",
      opts = {
        completion = {
          list = {
            selection = {
              preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
              auto_insert = true,
            },
          },
          menu = {
            border = "rounded",
            -- true to automatically show the completion menu
            auto_show = true,

            -- nvim-cmp style menu
            draw = {
              columns = {
                { "label", "label_description", gap = 1 },
                { "kind_icon", "kind", gap = 1 }
              },
              components = {
                kind_icon = {
                  ellipsis = false,
                  text = function(ctx)
                    return require('lspkind').symbolic(ctx.kind, {
                      mode = 'symbol',
                      symbol_map = {
                        Codeium = "",
                      }
                    })
                  end,
                },
              },
            }
          },
          -- Show documentation when selecting a completion item
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = {
              border = "rounded",
            },
          },

          -- Display a preview of the selected item on the current line
          ghost_text = { enabled = true },
        },
        signature = {
          enabled = true,
          window = {
            border = "rounded",
          },
        },
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- See the full "keymap" documentation for information on defining your own keymap.
        keymap = {
          preset = 'enter',
          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'hide' },
          ['<S-e>'] = { 'hide', 'fallback' },
          ['<Enter>'] = { 'select_and_accept', 'fallback' },

          ['<C-y>'] = { 'select_and_accept' },

          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev' },
          ['<C-n>'] = { 'select_next' },

          ['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-j>'] = { 'scroll_documentation_down', 'fallback' },
          ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

          cmdline = {
            ['<C-e>'] = { 'hide' },
            ['<S-e>'] = { 'hide', 'fallback' },
            ['Enter'] = { 'select_and_accept' },
            ['<C-y>'] = { 'select_and_accept' },
            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev' },
            ['<C-n>'] = { 'select_next' },
            ['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-j>'] = { 'scroll_documentation_down', 'fallback' },
            ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
          }
        },

        appearance = {
          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
          -- Useful for when your theme doesn't support blink.cmp
          -- Will be removed in a future release
          use_nvim_cmp_as_default = true,
          -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'normal'
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lazydev', 'lsp', 'codeium', 'path', 'snippets', 'buffer', 'emoji'},
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
            codeium = {
              name = "codeium",
              module = "blink.compat.source",
              score_offset = 100,
            },
            markdown = {
              name = "RenderMarkdown",
              module = "render-markdown.integ.blink",
            },
            emoji = {
              name = "emoji",
              module = "blink-emoji",
              score_offset = 15,
              opts = { insert = true }
            },
          },
        },
      },
      opts_extend = { "sources.default" },
      config = function (_, opts)
        require("blink.compat").setup({})
        require("blink.cmp").setup(opts)
        require("codeium").setup({})
      end
    },
  }
  return data
end

return M
