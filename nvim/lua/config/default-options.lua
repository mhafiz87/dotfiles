local icon = require("config.icons")

local M = {}

M.diagnostic = {
  virtual_text = {
    source = false,
    prefix = "",
    format = function(diagnostic)
      return string.format(" ● %s (%s)", diagnostic.message, diagnostic.source)
    end
  },
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = icon.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icon.diagnostics.Warn,
      [vim.diagnostic.severity.INFO] = icon.diagnostics.Info,
      [vim.diagnostic.severity.HINT] = icon.diagnostics.Hint
    }
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = true,
    header = '',
    prefix = '',
  },
}

return M
