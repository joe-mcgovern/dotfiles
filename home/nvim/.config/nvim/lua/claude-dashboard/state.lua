local tmux = require("claude-dashboard.tmux")
local git = require("claude-dashboard.git")
local claude = require("claude-dashboard.claude")

local M = {}

--- Build the unified session state used by the UI.
--- @return table[] List of session state tables
function M.build()
  local sessions = tmux.get_sessions()
  local waiting = claude.get_waiting_panes()
  local primaries = claude.get_primaries()

  -- Track which panes are actually running Claude for cleanup
  local active_claude_panes = {}

  for _, session in ipairs(sessions) do
    session.branch = git.get_branch(session.path)
    session.pane_count = #session.panes

    session.claude_panes = {}
    active_claude_panes[session.name] = {}

    for _, pane in ipairs(session.panes) do
      if claude.is_claude_process(pane.command) then
        local is_primary = primaries[session.name] == pane.id
        local status = "active"
        active_claude_panes[session.name][pane.id] = true

        -- Check if this pane has a waiting notification
        local session_waiting = waiting[session.name]
        if session_waiting then
          for _, w in ipairs(session_waiting) do
            if w.pane == pane.id then
              status = "waiting"
              break
            end
          end
        end

        table.insert(session.claude_panes, {
          pane = pane.id,
          status = status,
          primary = is_primary,
        })
      end
    end

    session.has_primary = primaries[session.name] ~= nil
    session.waiting_count = 0
    for _, cp in ipairs(session.claude_panes) do
      if cp.status == "waiting" then
        session.waiting_count = session.waiting_count + 1
      end
    end
  end

  claude.cleanup_stale(active_claude_panes)

  return sessions
end

return M
