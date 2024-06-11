local M = {}

M.choices = { { label = "awake" } }

M.workspaces = {
  awake = {
    parameter = {
      label = "awake",
      cwd = os.getenv("userprofile"),
    },
  },
  home = {
    parameter = {
      label = "home",
      cwd = os.getenv("userprofile"),
    },
  },
}

return M
