local bufnr = vim.api.nvim_get_current_buf()

local function register_rust_keymaps(buffnr)
  local wk = require("which-key")
  local opts = { noremap = true, silent = true, buffer = buffnr, prefix = "<leader>" }
  wk.add({
    { "<leader>cr", "<cmd>RustLsp runnables<cr>", desc = "rust run", remap = false, buffer = buffnr },
    {
      "<leader>cl",
      function()
        vim.lsp.codelens.run()
      end,
      desc = "rust codelens",
      remap = false,
      buffer = buffnr,
    },
    {
      "<leader>cti",
      function()
        require("lsp-inlayhints").toggle()
      end,
      desc = "toggle inlay hints",
      remap = false,
      buffer = buffnr,
    },
  })
end

vim.cmd([[
  compiler rustc 
]])

register_rust_keymaps(bufnr)
