local M = {}

local state_dir = vim.fn.expand("~/.claude-dashboard/state")

--- Read all Claude state files from the state directory.
--- @return table<string, table[]> Map of session_name -> list of {pane, status, timestamp}
function M.get_waiting_panes()
  local waiting = {}
  local files = vim.fn.globpath(state_dir, "*.json", false, true)

  for _, filepath in ipairs(files) do
    local content = table.concat(vim.fn.readfile(filepath), "\n")
    local ok, data = pcall(vim.json.decode, content)
    if ok and data and data.session then
      if not waiting[data.session] then
        waiting[data.session] = {}
      end
      table.insert(waiting[data.session], {
        pane = data.pane,
        status = data.status,
        timestamp = data.timestamp,
      })
    end
  end

  return waiting
end

--- Check if a pane command looks like a Claude process.
--- @param command string The pane_current_command from tmux
--- @return boolean
function M.is_claude_process(command)
  return command == "volta-shim" or command == "claude" or command == "node"
end

--- Clean up stale state files for panes that no longer run Claude.
--- @param active_claude_panes table<string, table<string, boolean>> Map of session -> set of pane IDs running Claude
function M.cleanup_stale(active_claude_panes)
  local files = vim.fn.globpath(state_dir, "*.json", false, true)
  for _, filepath in ipairs(files) do
    local content = table.concat(vim.fn.readfile(filepath), "\n")
    local ok, data = pcall(vim.json.decode, content)
    if ok and data and data.session and data.pane then
      local session_panes = active_claude_panes[data.session]
      if not session_panes or not session_panes[data.pane] then
        os.remove(filepath)
      end
    end
  end
end

--- Read the primary pane assignments.
--- @return table<string, string> Map of session_name -> pane_id
function M.get_primaries()
  local primaries_file = vim.fn.expand("~/.claude-dashboard/primaries.json")
  if vim.fn.filereadable(primaries_file) == 0 then
    return {}
  end
  local content = table.concat(vim.fn.readfile(primaries_file), "\n")
  local ok, data = pcall(vim.json.decode, content)
  if ok and data then
    return data
  end
  return {}
end

--- Save primary pane assignment.
--- @param session string Session name
--- @param pane_id string Pane ID (e.g., "0.1")
function M.set_primary(session, pane_id)
  local primaries = M.get_primaries()
  primaries[session] = pane_id
  local primaries_file = vim.fn.expand("~/.claude-dashboard/primaries.json")
  vim.fn.mkdir(vim.fn.expand("~/.claude-dashboard"), "p")
  local encoded = vim.json.encode(primaries)
  vim.fn.writefile({ encoded }, primaries_file)
end

return M
