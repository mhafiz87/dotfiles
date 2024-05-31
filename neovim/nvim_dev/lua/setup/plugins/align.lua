return {
   "echasnovski/mini.align",
   version = false,
   event = "BufEnter",
   config = function()
     local align = require("mini.align")
     align.setup()
   end,
}

