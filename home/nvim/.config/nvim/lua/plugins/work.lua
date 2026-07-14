local workPlugins = vim.fn.expand("~/.config/nvim-local/plugins.lua")
if vim.uv.fs_stat(workPlugins) then
  return dofile(workPlugins)
end

return {}
