return {
  {
    "gbprod/substitute.nvim",
    event = "VeryLazy",
    config = function()
      require("substitute").setup()
      -- keymaps for substitues
      vim.keymap.set("n", "r", require("substitute").operator, { noremap = true })
      vim.keymap.set("n", "rr", require("substitute").line, { noremap = true })
      vim.keymap.set("n", "R", require("substitute").eol, { noremap = true })
      vim.keymap.set("x", "r", require("substitute").visual, { noremap = true })
    end,
  },
}
