return {
  -- TokenFlow plugin
  {
    "DataDog/tokenflow.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    config = function(_, opts)
      require("tokenflow").setup(opts)

      -- Suggested keymaps
      vim.keymap.set("i", "<Tab>", function()
        require("tokenflow").suggestion.accept()
      end, { desc = "Accept suggestion" })

      vim.keymap.set("i", "<C-e>", function()
        require("tokenflow").suggestion.cancel()
      end, { desc = "Cancel suggestion" })

      vim.keymap.set("n", "<leader>tp", function()
        require("tokenflow").panel.open()
      end, { desc = "Open completion panel" })

      vim.keymap.set("n", "<leader>tc", function()
        require("tokenflow").inspect_context()
      end, { desc = "Inspect completion context" })
    end,
  },

  -- Update blink.cmp to remove codeium
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
