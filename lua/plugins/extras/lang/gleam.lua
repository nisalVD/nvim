return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gleam = {},
    },
    setup = {
      gleam = function(_, opts)
        local lspconfig = require("lspconfig")
        lspconfig.gleam.setup({})
      end,
    },
  },
}
