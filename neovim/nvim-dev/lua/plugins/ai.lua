local prefix = "<Leader>a"
local enabled = true

-- if global variable is not nil
-- if vim.g.ai_status ~= nil then
--   enabled = false
-- end

if vim.g.ai_status == 1 then
  enabled = false
end

return {
  {
    "zbirenbaum/copilot.lua",
    enabled = enabled,
    cmd = "Copilot",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        ["*"] = true,
        ["markdown"] = false,
        ["text"] = false,
      },
    },
  },
}
