return {
  {
    "rest-nvim/rest.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
    ft = "http",
    keys = {
      { "<leader>rt", "<Plug>RestNvim", desc = "Execute HTTP request" },
    },
  },
}
