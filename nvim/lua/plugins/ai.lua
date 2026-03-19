return {
  {
    enabled = true,
    "zbirenbaum/copilot.lua",
    dependencies = {
      {
        "copilotlsp-nvim/copilot-lsp",
        config = function ()
          vim.g.copilot_nes_debounce = 500
          -- vim.lsp.enable("copilot_ls")
        end
      }
    },
    cmd = "Copilot",
    event = { "BufReadPost", "BufNewFile", "InsertEnter" },
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = true },
        filetypes = {
          markdown = true,
          help = true,
        },
        nes = {
          enabled = true
        },
        -- auth_provider_url = "http://acme.ghe.com"
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end
  },
}