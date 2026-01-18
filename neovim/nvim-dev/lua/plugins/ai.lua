local prefix = "<Leader>a"

return {
  {
    "zbirenbaum/copilot.lua",
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
