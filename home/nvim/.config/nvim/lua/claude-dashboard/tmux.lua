local M = {}

--- Parse tmux sessions and their panes into a structured table.
--- @return table[] List of session tables with name, path, and panes
function M.get_sessions()
  local sessions = {}
  local session_output = vim.fn.systemlist("tmux list-sessions -F '#{session_name}\t#{session_path}' 2>/dev/null")
  if vim.v.shell_error ~= 0 then
    return sessions
  end

  local session_map = {}
  for _, line in ipairs(session_output) do
    local name, path = line:match("^(.+)\t(.+)$")
    if name then
      local session = {
        name = name,
        path = path,
        panes = {},
      }
      table.insert(sessions, session)
      session_map[name] = session
    end
  end

  local pane_output = vim.fn.systemlist(
    "tmux list-panes -a -F '#{session_name}\t#{window_index}.#{pane_index}\t#{pane_current_command}' 2>/dev/null"
  )
  if vim.v.shell_error == 0 then
    for _, line in ipairs(pane_output) do
      local sname, pane_id, cmd = line:match("^(.+)\t(.+)\t(.+)$")
      if sname and session_map[sname] then
        table.insert(session_map[sname].panes, {
          id = pane_id,
          command = cmd,
        })
      end
    end
  end

  return sessions
end

return M
