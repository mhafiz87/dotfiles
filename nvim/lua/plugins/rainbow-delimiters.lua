return{
  enabled = true,
  "HiPhish/rainbow-delimiters.nvim",
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters.setup")
    rainbow_delimiters.setup({})
  end,
}

