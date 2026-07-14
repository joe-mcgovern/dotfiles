local workConfig = vim.fn.expand("~/.config/nvim-local/go.lua")
if vim.uv.fs_stat(workConfig) then
  return dofile(workConfig)
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = false,
              compositeLiteralFields = false,
              compositeLiteralTypes = false,
              constantValues = false,
              functionTypeParameters = false,
              parameterNames = false,
              rangeVariableTypes = false,
            },
            directoryFilters = {
              "-.git",
              "-.vscode",
              "-.idea",
              "-node_modules",
              "-vendor",
              "-build",
              "-bin",
              "-dist",
              "-testdata",
              "-docs",
              "-tmp",
              "-temp",
              "-bazel-bin",
              "-bazel-out",
              "-bazel-testlogs",
            },
          },
        },
      },
    },
  },
}
