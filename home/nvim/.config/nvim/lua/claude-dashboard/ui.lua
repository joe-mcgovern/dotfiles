local state = require("claude-dashboard.state")
local actions = require("claude-dashboard.actions")

local M = {}

local buf = nil
local win = nil
local sessions = {}
local ns_id = vim.api.nvim_create_namespace("claude_dashboard")

local HEADER_LINES = 3 -- title + column headers + separator

local function close()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  win = nil
  buf = nil
end

local function get_selected_session()
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return nil
  end
  local cursor = vim.api.nvim_win_get_cursor(win)
  local row = cursor[1]
  local idx = row - HEADER_LINES
  if idx >= 1 and idx <= #sessions then
    return sessions[idx]
  end
  return nil
end

local function format_claude_col(session)
  local count = #session.claude_panes
  if count == 0 then
    return "  -"
  end
  local parts = {}
  if session.has_primary then
    table.insert(parts, "*")
  else
    table.insert(parts, " ")
  end
  table.insert(parts, tostring(count))
  if session.waiting_count > 0 then
    table.insert(parts, string.format("(%d!)", session.waiting_count))
  end
  return table.concat(parts, " ")
end

local function render()
  sessions = state.build()

  local col_session_w = 20
  local col_branch_w = 30
  local col_claude_w = 12
  local col_panes_w = 6
  local total_w = col_session_w + col_branch_w + col_claude_w + col_panes_w + 6

  local lines = {}
  local highlights = {}

  -- Title
  local title = "  Claude Dashboard"
  local pad = total_w - #title - #"[r]efresh  "
  if pad < 1 then pad = 1 end
  table.insert(lines, title .. string.rep(" ", pad) .. "[r]efresh  ")

  -- Column headers
  local header = string.format(
    "  %-" .. col_session_w .. "s %-" .. col_branch_w .. "s %-" .. col_claude_w .. "s %-" .. col_panes_w .. "s",
    "Session", "Branch", "Claude", "Panes"
  )
  table.insert(lines, header)

  -- Separator
  table.insert(lines, "  " .. string.rep("-", total_w - 4))

  -- Session rows
  for i, session in ipairs(sessions) do
    local branch_display = session.branch or "(none)"
    if #branch_display > col_branch_w then
      branch_display = branch_display:sub(1, col_branch_w - 3) .. "..."
    end

    local line = string.format(
      "  %-" .. col_session_w .. "s %-" .. col_branch_w .. "s %-" .. col_claude_w .. "s %-" .. col_panes_w .. "d",
      session.name,
      branch_display,
      format_claude_col(session),
      session.pane_count
    )
    table.insert(lines, line)

    if session.waiting_count > 0 then
      table.insert(highlights, { line = HEADER_LINES + i - 1, group = "DiagnosticWarn" })
    end
  end

  -- Footer
  table.insert(lines, "")
  table.insert(lines, "  [Enter] Jump  [p] Prompt  [s] Set Primary  [q] Quit")

  return lines, highlights
end

function M.open()
  if win and vim.api.nvim_win_is_valid(win) then
    close()
    return
  end

  local lines, highlights = render()
  local width = 74
  local height = #lines
  local ui = vim.api.nvim_list_uis()[1]
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)

  buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Apply highlights
  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(buf, ns_id, hl.group, hl.line, 0, -1)
  end

  -- Title highlight
  vim.api.nvim_buf_add_highlight(buf, ns_id, "Title", 0, 0, -1)
  -- Header highlight
  vim.api.nvim_buf_add_highlight(buf, ns_id, "Comment", 1, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns_id, "Comment", 2, 0, -1)

  -- Place cursor on first session row
  vim.api.nvim_win_set_cursor(win, { HEADER_LINES + 1, 0 })

  -- Keymaps
  local opts = { buffer = buf, nowait = true, silent = true }

  vim.keymap.set("n", "q", close, opts)
  vim.keymap.set("n", "<Esc>", close, opts)

  vim.keymap.set("n", "<CR>", function()
    local session = get_selected_session()
    if session then
      close()
      actions.jump_to_session(session.name)
    end
  end, opts)

  vim.keymap.set("n", "p", function()
    local session = get_selected_session()
    if not session then return end
    close()
    vim.ui.input({ prompt = "Claude prompt for " .. session.name .. ": " }, function(input)
      if input and input ~= "" then
        actions.dispatch_prompt(session.name, input)
      end
    end)
  end, opts)

  vim.keymap.set("n", "s", function()
    local session = get_selected_session()
    if not session or #session.claude_panes == 0 then
      vim.notify("No Claude panes in this session", vim.log.levels.WARN)
      return
    end
    if #session.claude_panes == 1 then
      actions.set_primary(session.name, session.claude_panes[1].pane)
      M.refresh()
      return
    end
    -- Multiple Claude panes -- let user pick
    local items = {}
    for _, cp in ipairs(session.claude_panes) do
      local label = cp.pane
      if cp.primary then label = label .. " (current primary)" end
      if cp.status == "waiting" then label = label .. " [waiting]" end
      table.insert(items, label)
    end
    vim.ui.select(items, { prompt = "Select primary Claude pane:" }, function(_, idx)
      if idx then
        actions.set_primary(session.name, session.claude_panes[idx].pane)
        M.refresh()
      end
    end)
  end, opts)

  vim.keymap.set("n", "r", function()
    M.refresh()
  end, opts)
end

function M.refresh()
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local cursor_pos = vim.api.nvim_win_get_cursor(win)
  local lines, highlights = render()
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(buf, ns_id, hl.group, hl.line, 0, -1)
  end
  vim.api.nvim_buf_add_highlight(buf, ns_id, "Title", 0, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns_id, "Comment", 1, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns_id, "Comment", 2, 0, -1)

  -- Restore cursor, clamped to valid range
  local max_row = #lines
  local new_row = math.min(cursor_pos[1], max_row)
  if new_row < HEADER_LINES + 1 then new_row = HEADER_LINES + 1 end
  vim.api.nvim_win_set_cursor(win, { new_row, 0 })
end

return M
