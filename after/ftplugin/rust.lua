local bufnr = vim.api.nvim_get_current_buf()

local function register_rust_keymaps(buffnr)
  local wk = require("which-key")
  local opts = { noremap = true, silent = true, buffer = buffnr, prefix = "<leader>" }
  wk.register({
    c = {
      r = { "<cmd>RustLsp runnables<cr>", "rust run" },
      l = {
        function()
          vim.lsp.codelens.run()
        end,
        "rust codelens",
      },
      t = {
        "toggle things",
        i = {
          function()
            require("lsp-inlayhints").toggle()
          end,
          "toggle inlay hints",
        },
      },
    },
  }, opts)
end

vim.cmd([[
  compiler rustc 
]])

register_rust_keymaps(bufnr)
