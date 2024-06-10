local M = {}

function M.basename(s)
  return string.match(string.gsub(s, '(.*[/\\])(.*)', '%2'), "[a-zA-Z0-9_-]+")
end

function M.table_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function M.remove_exe(s)
  local temp = string.gmatch(s, "%.")
  for i in temp do
    print(i)
  end
end

return M
