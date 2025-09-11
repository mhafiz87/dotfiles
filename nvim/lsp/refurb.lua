---@type vim.lsp.Config
return {
  cmd = { "refurb" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", ".git" },
  settings = {}
}
