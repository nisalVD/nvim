return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      servers = {
        -- denols = {},
      },
      setup = {
        -- denols = function(_, opts)
        --   local lsp_utils = require("plugins.lsp.utils")
        --   lsp_utils.on_attach(function(client, buffnr)
        --     if client.name == "denols" then
        --       require("null-ls").disable({ name = "eslint_d" })
        --       require("plugins.extras.lang.typescript-binds").register_rust_keymaps(buffnr)
        --     end
        --   end)
        --   require("lspconfig").denols.setup({
        --     root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
        --   })
        --   return true
        -- end,
      },
    },
  },
}
