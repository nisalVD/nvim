return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      servers = {
        clangd = {},
      },
      setup = {
        clangd = function(_, opts)
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          }

          require("lspconfig").clangd.setup({
            capabilities = capabilities,
            cmd = { "clangd", "-offset-encoding=utf-16" },
          })
          require("plugins.lsp.utils").on_attach(function(client, buffer)
            -- stylua: ignore
            if client.name == "clangd" then
							require("plugins.extras.lang.cpp-binds").register_cpp_binds(buffer)
            end
          end)

          return true -- dont call the base implementation
        end,
      },
    },
  },
}
