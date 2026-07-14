-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Use 'jk' as escape key in insert mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Use 'fz' to open fzf-lua files finder
vim.keymap.set("n", "fz", "<cmd>FzfLua files<cr>", { desc = "Find files with fzf-lua" })

-- Use 'fcz' to open fzf-lua files finder in current buffer's directory
vim.keymap.set("n", "fl", function()
  local current_dir = vim.fn.expand("%:p:h")
  require("fzf-lua").files({ cwd = current_dir })
end, { desc = "Find files in current buffer's directory" })

-- Use '<leader>b' to open fzf-lua buffers picker
vim.keymap.set("n", "<leader>b", "<cmd>FzfLua buffers<cr>", { desc = "Find buffers with fzf-lua" })

-- Create :Rg command similar to old vimrc setup
vim.api.nvim_create_user_command("Rg", function(opts)
  require("fzf-lua").live_grep({ search = opts.args })
end, { nargs = "*", desc = "Live grep with fzf-lua" })

-- Create :Rgc command to grep in current buffer's directory
vim.api.nvim_create_user_command("Rgl", function(opts)
  local current_dir = vim.fn.expand("%:p:h")
  require("fzf-lua").live_grep({ search = opts.args, cwd = current_dir })
end, { nargs = "*", desc = "Live grep in current buffer's directory" })

-- Copy relative path to clipboard with '<leader>yp'
vim.keymap.set("n", "<leader>yp", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("", path) -- unnamed register (for 'p')
  vim.fn.setreg("+", path) -- system clipboard
  print("Copied: " .. path)
end, { desc = "Copy relative path" })

-- Jump to definition with C-]
vim.keymap.set("n", "<C-]>", function()
  vim.lsp.buf.definition()
end, { desc = "Go to definition" })

-- Run the Go test under cursor in a tmux pane via vim-dispatch
vim.keymap.set("n", "<leader>gtn", function()
  local filename = vim.fn.expand("%:t")
  if vim.bo.filetype ~= "go" or not filename:match("_test%.go$") then
    vim.notify("Not a Go test file", vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]

  local test_name = nil
  for i = cursor_line, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    local name = line:match("^func%s+(Test[%w_]+)%s*%(")
    if name then
      test_name = name
      break
    end
  end

  if not test_name then
    vim.notify("No test function found above cursor", vim.log.levels.WARN)
    return
  end

  local pkg_dir = vim.fn.expand("%:p:h")
  local test_cmd = string.format("go test -v -run ^%s$ %s", test_name, pkg_dir)
  vim.cmd(string.format("Start -wait=always echo '=> %s' && %s", test_cmd, test_cmd))
end, { desc = "Run Go test under cursor" })

-- Create :ReloadKeymaps command to reload this file
vim.api.nvim_create_user_command("ReloadKeymaps", function()
  local keymaps_file = vim.fn.stdpath("config") .. "/lua/config/keymaps.lua"
  vim.cmd.source(keymaps_file)
  print("Reloaded keymaps from " .. keymaps_file)
end, { desc = "Reload keymaps configuration" })
