-- bowlcut: jump from generated atlas proto function names to their implementations.
-- Strips configured prefixes/suffixes, then ripgreps for the real Go function definition.
-- Falls back to LSP go-to-definition when the word has no known prefix or no matches are found.
-- Searches outward from the current file's directory toward the git root for speed.

local prefixes = { "ExecuteActivity", "ExecuteWorkflow", "ExecuteChildWorkflow" }
local suffixes = { "Async" }

local function strip_prefixes(word)
  for _, prefix in ipairs(prefixes) do
    if word:sub(1, #prefix) == prefix then
      return word:sub(#prefix + 1), true
    end
  end
  return word, false
end

local function strip_suffixes(word, prefix_was_removed)
  if not prefix_was_removed then
    return word
  end
  for _, suffix in ipairs(suffixes) do
    if word:sub(-#suffix) == suffix then
      return word:sub(1, -(#suffix + 1))
    end
  end
  return word
end

local function find_git_root()
  local path = vim.fn.expand("%:p:h")
  local home = vim.env.HOME or ""
  while path ~= "/" and path ~= "" and path ~= home do
    if vim.fn.isdirectory(path .. "/.git") == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil
end

local function rg_args(query, search_dir)
  return {
    "rg",
    "--column", "--line-number", "--no-heading", "--color=never",
    "--max-count=1",
    "--glob", "*.go",
    "--glob", "!*.pb.go",
    "--", query, search_dir,
  }
end

local function parse_results(obj)
  local output = obj.stdout or ""
  local results = {}
  for line in output:gmatch("[^\n]+") do
    table.insert(results, line)
  end
  return results
end

local function handle_results(results, stripped, query, root)
  if #results == 1 then
    local parts = vim.split(results[1], ":")
    local filename = parts[1]
    local line = tonumber(parts[2])
    vim.cmd("edit " .. vim.fn.fnameescape(filename))
    vim.api.nvim_win_set_cursor(0, { line, 0 })
    vim.fn.search(stripped)
    return
  end

  require("fzf-lua").grep({
    search = query,
    cwd = root,
    no_esc = true,
    rg_opts = "--column --line-number --no-heading --color=always --smart-case"
      .. " --glob '*.go' --glob '!*.pb.go'",
  })
end

-- Recursively search outward from search_dir toward root.
local function search_expanding(search_dir, root, query, stripped)
  vim.system(rg_args(query, search_dir), { text = true }, vim.schedule_wrap(function(obj)
    local results = parse_results(obj)

    if #results > 0 then
      handle_results(results, stripped, query, root)
      return
    end

    if search_dir == root then
      vim.lsp.buf.definition()
      return
    end

    local parent = vim.fn.fnamemodify(search_dir, ":h")
    if parent == search_dir then
      vim.lsp.buf.definition()
      return
    end

    search_expanding(parent, root, query, stripped)
  end))
end

local function bowlcut_jump()
  local word = vim.fn.expand("<cword>")

  local stripped, prefix_removed = strip_prefixes(word)
  stripped = strip_suffixes(stripped, prefix_removed)

  if stripped == word then
    vim.lsp.buf.definition()
    return
  end

  local root = find_git_root()
  if not root then
    vim.lsp.buf.definition()
    return
  end

  local query = string.format([[func \(.*\) %s\(]], stripped)
  local start_dir = vim.fn.expand("%:p:h")

  search_expanding(start_dir, root, query, stripped)
end

return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<C-]>", bowlcut_jump, ft = "go", desc = "Bowlcut jump (LSP fallback)" },
  },
}
