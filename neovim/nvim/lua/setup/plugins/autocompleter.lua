return {
  "hrsh7th/nvim-cmp", -- neovim completion engine
  event = "BufReadPre",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- neovim built-in language server client
    "hrsh7th/cmp-buffer", -- source for buffer words
    "hrsh7th/cmp-path", -- source for filesytem paths
    "hrsh7th/cmp-nvim-lsp-signature-help", -- source for displaying function signatures with the current parameter
    "hrsh7th/cmp-cmdline", -- source for vim's command line
    "saadparwaiz1/cmp_luasnip", -- luasnip completion source
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets", -- Snippets collection for a set of different programming languages.
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },

  config = function()
    local cmp = require("cmp") -- nvim-cmp
    -- local cmp_nvim_lsp = require("cmp_nvim_lsp") -- cmp-nvim-lsp
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "\\snippets\\vscode\\" } }) -- vscode style snippet
    require("luasnip.loaders.from_vscode").lazy_load() -- vscode style snippet

    cmp.setup({
      completion = {
        completeopt = "menu, menuone, preview, noselect",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_next_item(),
        ["<C-j>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-t>"] = cmp.mapping.complete(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- snippets
        { name = 'nvim_lsp_signature_help' },  -- function signature with current parameter
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      }),
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      }),
      window = {
        -- Add borders to completions popups
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          preset = "codicons",
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end,
}
