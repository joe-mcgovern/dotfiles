local M = {}

M.config = {
  keybinding = "<leader>cd",
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  vim.keymap.set("n", M.config.keybinding, function()
    require("claude-dashboard.ui").open()
  end, { desc = "Open Claude Dashboard" })
end

return M
