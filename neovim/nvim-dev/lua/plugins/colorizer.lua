return {
  enabled = true,
  "catgoose/nvim-colorizer.lua",
  config = function()
    local colorizer = require("colorizer")
    colorizer.setup({
      user_default_options = {
        rgb_fn = true,
      }
    })
  end
}
