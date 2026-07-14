return {
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb", -- GitHub support for GBrowse
    },
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
    },
  },
}
