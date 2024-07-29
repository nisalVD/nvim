return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      glslls = {},
    },
    setup = {
      glslls = function(_, opts)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }

        require("lspconfig").glslls.setup({
          cmd = { "glslls", "--stdin", "--target-env", "opengl" },
          capabilities = capabilities,
        })
        require("plugins.lsp.utils").on_attach(function(client, buffer)
            -- stylua: ignore
            if client.name == "glslls" then
							require("plugins.extras.lang.cpp-binds").register_cpp_binds(buffer)
            end
        end)

        return true -- dont call the base implementation
      end,
    },
  },
}
