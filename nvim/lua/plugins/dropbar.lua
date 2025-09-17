local utils = require("utils")
local build = ""
if utils.is_windows() then
  -- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
  build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
else
  build = "make"
end

return {
  enabled = true,
  'Bekaboo/dropbar.nvim',
  -- optional, but required for fuzzy finder support
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = build
  },
  config = function()
    local dropbar_api = require('dropbar.api')
    vim.keymap.set( "n", "<leader>wb", dropbar_api.pick, { desc = "[w]inbar [b]avigation", noremap = true, silent = true })
  end
}
