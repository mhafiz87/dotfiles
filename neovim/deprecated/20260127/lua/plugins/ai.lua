return {
  {
    enabled = true,
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      local neocodeium = require("neocodeium")
      neocodeium.setup()
      vim.keymap.set("i", "<A-f>", function()
        require("neocodeium").accept()
      end, { desc = "[neocodeium] accept" })
      vim.keymap.set("i", "<A-w>", function()
        require("neocodeium").accept_word()
      end, { desc = "[neocodeium] accept word" })
      vim.keymap.set("i", "<A-a>", function()
        require("neocodeium").accept_line()
      end, { desc = "[neocodeium] accept line" })
      vim.keymap.set("i", "<A-e>", function()
        require("neocodeium").cycle_or_complete()
      end, { desc = "[neocodeium] cycle or complete" })
      vim.keymap.set("i", "<A-r>", function()
        require("neocodeium").cycle_or_complete(-1)
      end, { desc = "[neocodeium] cycle or complete" })
      vim.keymap.set("i", "<A-c>", function()
        require("neocodeium").clear()
      end, { desc = "[neocodeium] clear" })
    end
  },
  {
    enabled = true,
    "zbirenbaum/copilot.lua",
    dependencies = {
    },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          accept = false,
        },
        panel = { enabled = false }
      })
    end,
  }
}
