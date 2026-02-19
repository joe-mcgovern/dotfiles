return {
  dir = vim.fn.stdpath("config") .. "/lua/claude-dashboard",
  name = "claude-dashboard",
  keys = {
    { "<leader>cd", desc = "Open Claude Dashboard" },
  },
  config = function()
    require("claude-dashboard").setup({
      keybinding = "<leader>cd",
    })
  end,
}
