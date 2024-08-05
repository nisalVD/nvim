return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      "mrjones2014/legendary.nvim",
      "echasnovski/mini.icons",
    },
    config = function()
      local wk = require("which-key")
      -- wk.setup({
      --   plugins = { spelling = true },
      --   key_labels = { ["<leader>"] = "," },
      -- })
      wk.add({
        { "<leader>p", group = "files" },
        { "<leader>y", '"+y', desc = "copy to clipboard", mode = { "n", "v" } },
        -- { "<leader>x", '"+x', desc = "delete to clipboard", mode = { "n", "v" } },
      })
    end,
  },
}
