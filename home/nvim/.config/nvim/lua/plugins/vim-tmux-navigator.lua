return {
  "alexghergh/nvim-tmux-navigation",
  keys = {

    { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Go to the previous pane" },

    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Got to the left pane" },

    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Got to the down pane" },

    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Got to the up pane" },

    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Got to the right pane" },
  },
  config = function()
    local nvim_tmux_nav = require("nvim-tmux-navigation")

    nvim_tmux_nav.setup({
      disable_when_zoomed = true, -- defaults to false
    })

    vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
    vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
    vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
    vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
    vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
  end,
}
