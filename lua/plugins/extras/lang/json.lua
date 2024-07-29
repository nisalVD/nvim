return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim", "hrsh7th/cmp-nvim-lsp" },
    opts = {
      servers = {
        jsonls = {},
      },
      setup = {
        jsonls = function(_, opts)
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          }

          require("lspconfig").jsonls.setup({
            capabilities = capabilities,
            settings = {
              json = {
                schemas = require("schemastore").json.schemas({
                  select = {
                    ".eslintrc",
                    "package.json",
                  },
                }),
                validate = { enable = true },
              },
            },
          })

          return true -- dont implement base implementation
        end,
      },
    },
  },
}
