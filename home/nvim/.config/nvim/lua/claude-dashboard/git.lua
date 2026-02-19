local M = {}

--- Get the current git branch for a directory path.
--- @param path string Absolute path to check
--- @return string|nil Branch name or nil if not a git repo
function M.get_branch(path)
  local result = vim.fn.systemlist(string.format("git -C %s branch --show-current 2>/dev/null", vim.fn.shellescape(path)))
  if vim.v.shell_error ~= 0 or #result == 0 then
    return nil
  end
  return result[1]
end

return M
