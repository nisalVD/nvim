return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        harper_ls = {
          filetypes = { "markdown" },
        },
      },
      setup = {
        harper_ls = function()
          -- change harper-ls getting initialized by lsp
          return false
        end,
      },
    },
  },
}
