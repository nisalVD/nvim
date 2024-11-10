return {
  "akinsho/nvim-toggleterm.lua",
  opts = {
    direction = "float",
  },
  cmd = "ToggleTerm",
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "ToggleTerm", mode = { "n", "t" } },
  },
}
