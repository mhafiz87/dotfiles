return {
    enabled = true,
    "nvimtools/hydra.nvim",
    config = function()
        -- create hydras in here
      local Hydra = require("hydra")
      require('hydra').setup({
          debug = false,
          exit = false,
          foreign_keys = nil,
          color = "red",
          timeout = false,
          invoke_on_body = false,
          hint = {
              show_name = true,
              position = { "bottom" },
              offset = 0,
              float_opts = { },
          },
          on_enter = nil,
          on_exit = nil,
          on_key = nil,
      })
      Hydra(
        {
          name = "window navigation",
          mode = "n",
          body = "<c-w>",
          config = {
            hint = {
              type = "window",
              position = "bottom-right"
            }
          },
          hint = [[
Window Navigation
^
_h_: go to left window
_l_: go to right window
_j_: go to bottom window
_k_: go to top window
_+_: increase height
_-_: decrease height
_>_: increase width
_<_: decrease width
_=_: equal
_|_: max width
_\\_: max height
^
          ]],
          heads = {
            {"h", "<c-w>h", {desc = "go to left window",silent = true}},
            {"l", "<c-w>l", {desc = "go to right window",silent = true}},
            {"j", "<c-w>j", {desc = "go to bottom window",silent = true}},
            {"k", "<c-w>k", {desc = "go to top window",silent = true}},
            {"+", "<c-w>+", {desc = "increase height ",silent = true}},
            {"-", "<c-w>-", {desc = "decrease height",silent = true}},
            {">", "<c-w>>", {desc = "increase width",silent = true}},
            {"<", "<c-w><", {desc = "decrease width",silent = true}},
            {"=", "<c-w>=", {desc = "equal window size",silent = true}},
            {"|", "<c-w>|", {desc = "max width",silent = true}},
            {"\\", "<c-w>_", {desc = "max height",silent = true}},
          }
        }
      )
    end
}