local M = {}

M.plugins_path = vim.fn.stdpath("data") .. "/lazy/"

M.is_plugin_installed = function(plugins_name)
  if vim.fn.empty(vim.fn.glob(M.plugins_path .. plugins_name)) > 0 then
    return false
  else
    return true
  end
end

return M
