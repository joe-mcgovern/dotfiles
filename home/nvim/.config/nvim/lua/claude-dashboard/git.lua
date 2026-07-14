local M = {}

--- Get git branches for multiple directory paths in a single shell invocation.
--- @param paths string[] List of absolute paths to check
--- @return table<string, string> Map of path -> branch name (missing if not a git repo)
function M.get_branches(paths)
  if #paths == 0 then
    return {}
  end

  -- Build a single shell command that prints "path\tbranch" for each repo
  local parts = {}
  for _, path in ipairs(paths) do
    table.insert(parts, string.format(
      "b=$(git -C %s branch --show-current 2>/dev/null) && printf '%%s\\t%%s\\n' %s \"$b\"",
      vim.fn.shellescape(path),
      vim.fn.shellescape(path)
    ))
  end
  local cmd = table.concat(parts, "; ")
  local output = vim.fn.systemlist(cmd)

  local branches = {}
  for _, line in ipairs(output) do
    local path, branch = line:match("^(.+)\t(.+)$")
    if path and branch and branch ~= "" then
      branches[path] = branch
    end
  end
  return branches
end

return M
