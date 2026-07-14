local claude = require("claude-dashboard.claude")

local M = {}

--- Switch the tmux client to the given session.
--- @param session_name string
function M.jump_to_session(session_name)
  vim.fn.system(string.format("tmux switch-client -t %s", vim.fn.shellescape(session_name)))
end

--- Open a new tmux pane in the target session and run a Claude prompt.
--- @param session_name string
--- @param prompt string The prompt text to send to Claude
function M.dispatch_prompt(session_name, prompt)
  local escaped = prompt:gsub("'", "'\\''")
  local cmd = string.format(
    "tmux split-window -t %s -h \"claude -p '%s'\"",
    vim.fn.shellescape(session_name),
    escaped
  )
  vim.fn.system(cmd)
end

--- Set the primary Claude pane for a session.
--- @param session_name string
--- @param pane_id string
function M.set_primary(session_name, pane_id)
  claude.set_primary(session_name, pane_id)
end

return M
