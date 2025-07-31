return {
  -- Command and arguments to start the server.
  cmd = { "ruff", "server" },

  -- Filetypes to automatically attach to.
  filetypes = { "python" },

  -- Sets the "root directory" to the parent directory of the file in the
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = {
    {
      "pyproject.toml",
      "ruff.toml",
      ".ruff.toml"
    },
    ".git",
  },

  -- Specific settings to send to the server. The schema for this is
  -- defined by the server. For example the schema for lua-language-server
  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {}
}
