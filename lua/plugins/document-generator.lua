return {
  "kkoomen/vim-doge",
  event = "BufReadPre",
  build = ":call doge#install()",
  config = function()
    vim.g.doge_enable_mappings = 0
  end,
}
