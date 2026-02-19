return {
  "saghen/blink.cmp",
  commit = "0aa180e6eb3415f90a4f1b86801db9cab0c0ca7b", -- pin to v1.8.0; v1.9.x has ghost_text + noice.nvim crash
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}