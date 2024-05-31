which_key = require("which-key")
which_key.register({
  -- Base
  -- Buffers Controls
  ["<leader>b"] = {
    name = "+buffer controls",
    mode = "n",
  },

  -- Quickfix
  ["<leader>q"] = {
    mode = "n",
    name = "+quickfix",
  },

  -- Find files/themes/buffer using telescope
  ["<leader>f"] = {
    mode = "n",
    name = "+find (files/themes/buffer)",
  },

  -- g
  g = {
    mode = {"n"},
    name = "+prefix / mini.align / open in browser",
  },

  -- Surround
  ["<leader>s"] = {
    mode = {"n", "v"},
    name = "+surround",
  }
})
