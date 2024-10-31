return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    ft = { "rust" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
          on_attach = function(client, bufnr)
            require("plugins.lsp.keymaps").on_attach(client, bufnr)
          end,
        },
      }
    end,
  },
  -- TODO: fix this
  -- {
  --   "saecki/crates.nvim",
  --   event = { "BufRead Cargo.toml" },
  --   dependencies = {
  --     "hrsh7th/nvim-cmp",
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = function()
  --     require("crates").setup({
  --       lsp = {
  --         enabled = true,
  --         actions = true,
  --         completion = true,
  --       },
  --       src = {
  --         cmp = {
  --           enabled = true,
  --         },
  --       },
  --     })
  --   end,
  -- },
}
