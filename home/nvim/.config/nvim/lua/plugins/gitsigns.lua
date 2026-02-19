return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      watch_gitdir = {
        enable = false, -- Disable .git/ directory watching to prevent race conditions with background git hooks
      },
      update_debounce = 1000,
    },
  },
}
