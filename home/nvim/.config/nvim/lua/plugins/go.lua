return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        cmd = { "/opt/homebrew/bin/dd-gopls" },
        cmd_env = {
          GOPLS_DISABLE_MODULE_LOADS = "1",
        },
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
              -- Bazel directories
              "-bazel-bin",
              "-bazel-dd-source",
              "-bazel-out",
              "-bazel-testlogs",
            },
          },
        },
      },
    },
  },
}

